import express, { Request, Response } from "express";
import { prisma } from "../utils/db";
import morgan from "morgan";

const app = express();

app.use(express.json());
app.use(morgan("dev"));

/**
 * Endpoint to create a new track
 * @param {string} name - The name of the track
 * @returns {Track} - The newly created track
 */
app.post("/tracks", async (req: Request, res: Response) => {
  const { name } = req.body;
  try {
    const track = await prisma.track.create({
      data: { name },
    });
    res.json(track);
  } catch (error) {
    console.error("Track creation error:", error);
    res.status(400).json({
      error: "Failed to create track",
      details: error instanceof Error ? error.message : "Unknown error",
    });
  }
});

/**
 * Endpoint to fetch all tracks
 * @returns {Track[]} - All tracks
 */
app.get("/tracks", async (req: Request, res: Response) => {
  try {
    const tracks = await prisma.track.findMany();
    res.json(tracks);
  } catch (error) {
    console.error("Track fetch error:", error);
    res.status(500).json({
      error: "Failed to fetch tracks",
      details: error instanceof Error ? error.message : "Unknown error",
    });
  }
});

/**
 * Endpoint to create a new speaker
 * @param {string} name - The name of the speaker
 * @returns {Speaker} - The newly created speaker
 */
app.post("/speakers", async (req: Request, res: Response) => {
  const { name } = req.body;
  try {
    const speaker = await prisma.speaker.create({
      data: { name },
    });
    res.json(speaker);
  } catch (error) {
    res.status(400).json({
      error: "Failed to create speaker",
      details: error instanceof Error ? error.message : "Unknown error",
    });
  }
});

/**
 * Endpoint to fetch all speakers
 * @returns {Speaker[]} - All speakers
 */
app.get("/speakers", async (req: Request, res: Response) => {
  const speakers = await prisma.speaker.findMany();
  res.json(speakers);
});

/**
 * Endpoint to create a new session
 * @param {Object} sessionData - The session data
 * @returns {Session} - The newly created session
 */
app.post("/sessions", async (req: Request, res: Response) => {
  const {
    name,
    start_time,
    end_time,
    date,
    location,
    description,
    session_id,
    is_virtual,
    event_name,
    timezone,
    trackIds,
    speakerIds,
  } = req.body;

  try {
    const session = await prisma.session.create({
      data: {
        name,
        start_time: new Date(start_time),
        end_time: new Date(end_time),
        date: new Date(date),
        location,
        description,
        session_id,
        is_virtual,
        event_name,
        timezone,
        tracks: {
          create:
            trackIds?.map((id: number) => ({
              track: { connect: { id } },
            })) || [],
        },
        speakers: {
          create:
            speakerIds?.map((id: number) => ({
              speaker: { connect: { id } },
            })) || [],
        },
      },
      include: {
        tracks: {
          include: {
            track: true,
          },
        },
        speakers: {
          include: {
            speaker: true,
          },
        },
        subSessions: true,
      },
    });
    res.json(session);
  } catch (error) {
    console.error("Session creation error:", error);
    res.status(400).json({
      error: "Failed to create session",
      details: error instanceof Error ? error.message : "Unknown error",
    });
  }
});

/**
 * Endpoint to fetch all sessions with optional filters
 * @param {string} event_name - Filter by event name
 * @param {string} date - Filter by date
 * @param {string} track_id - Filter by track ID
 * @param {string} speaker_id - Filter by speaker ID
 * @param {string} search - Search text in session name and description
 * @returns {Session[]} - Filtered sessions
 */
app.get("/sessions", async (req: Request, res: Response) => {
  const { event_name, date, track_id, speaker_id, search } = req.query;
  const where: any = {};

  if (event_name) where.event_name = event_name;
  if (date) where.date = new Date(date as string);
  if (track_id)
    where.tracks = {
      some: {
        track_id: parseInt(track_id as string),
      },
    };
  if (speaker_id)
    where.speakers = {
      some: {
        speaker_id: parseInt(speaker_id as string),
      },
    };
  if (search) {
    where.OR = [
      { name: { contains: search as string, mode: "insensitive" } },
      { description: { contains: search as string, mode: "insensitive" } },
    ];
  }

  try {
    const sessions = await prisma.session.findMany({
      where,
      select: {
        id: true,
        name: true,
        start_time: true,
        end_time: true,
        date: true,
        location: true,
        session_id: true,
        is_virtual: false,
        event_name: false,
        timezone: true,
        session_type: true,
        tracks: {
          select: {
            track: true,
          },
        },
        speakers: {
          select: {
            speaker: true,
          },
        },
        subSessions: false,
        description: false,
      },
    });
    res.json(sessions);
  } catch (error) {
    console.error("Session fetch error:", error);
    res.status(500).json({
      error: "Failed to fetch sessions",
      details: error instanceof Error ? error.message : "Unknown error",
    });
  }
});

/**
 * Endpoint to create a new sub-session
 * @param {Object} subSessionData - The sub-session data
 * @returns {SubSession} - The newly created sub-session
 */
app.post("/sub_sessions", async (req: Request, res: Response) => {
  const { parent_session_id, name, description, speakerIds } = req.body;

  try {
    const subSession = await prisma.subSession.create({
      data: {
        parent_session_id,
        name,
        description,
        speakers: {
          create:
            speakerIds?.map((id: number) => ({
              speaker: { connect: { id } },
            })) || [],
        },
      },
      include: {
        speakers: {
          include: {
            speaker: true,
          },
        },
      },
    });
    res.json(subSession);
  } catch (error) {
    console.error("Sub-session creation error:", error);
    res.status(400).json({
      error: "Failed to create sub-session",
      details: error instanceof Error ? error.message : "Unknown error",
    });
  }
});

/**
 * Endpoint to fetch all sub-sessions for a parent session
 * @param {string} parent_session_id - The ID of the parent session
 * @returns {SubSession[]} - All sub-sessions for the parent session
 */
app.get("/sub_sessions", async (req: Request, res: Response) => {
  const { parent_session_id } = req.query;
  const where: any = {};

  if (parent_session_id) {
    where.parent_session_id = parseInt(parent_session_id as string);
  }

  try {
    const subSessions = await prisma.subSession.findMany({
      where,
      include: {
        speakers: {
          include: {
            speaker: true,
          },
        },
      },
    });
    res.json(subSessions);
  } catch (error) {
    console.error("Sub-session fetch error:", error);
    res.status(500).json({
      error: "Failed to fetch sub-sessions",
      details: error instanceof Error ? error.message : "Unknown error",
    });
  }
});

const port = process.env.PORT || 3000;

app.listen(port, () => {
  console.log(`🚀 Server ready at: http://localhost:${port}`);
});

export default app;

module.exports = app;
