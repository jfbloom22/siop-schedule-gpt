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
    res.status(400).json({ error: "Failed to create track" });
  }
});

/**
 * Endpoint to fetch all tracks
 * @returns {Track[]} - All tracks
 */
app.get("/tracks", async (req: Request, res: Response) => {
  const tracks = await prisma.track.findMany();
  res.json(tracks);
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
    res.status(400).json({ error: "Failed to create speaker" });
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
    startTime,
    endTime,
    date,
    location,
    description,
    sessionId,
    isVirtual,
    eventName,
    timezone,
    trackIds,
    speakerIds,
  } = req.body;

  try {
    const session = await prisma.session.create({
      data: {
        name,
        startTime: new Date(startTime),
        endTime: new Date(endTime),
        date: new Date(date),
        location,
        description,
        sessionId,
        isVirtual,
        eventName,
        timezone,
        tracks: {
          connect: trackIds?.map((id: number) => ({ id })) || [],
        },
        speakers: {
          connect: speakerIds?.map((id: number) => ({ id })) || [],
        },
      },
      include: {
        tracks: true,
        speakers: true,
        subSessions: true,
      },
    });
    res.json(session);
  } catch (error) {
    res.status(400).json({ error: "Failed to create session" });
  }
});

/**
 * Endpoint to fetch all sessions with optional filters
 * @param {string} eventName - Filter by event name
 * @param {string} date - Filter by date
 * @param {string} trackId - Filter by track ID
 * @param {string} speakerId - Filter by speaker ID
 * @returns {Session[]} - Filtered sessions
 */
app.get("/sessions", async (req: Request, res: Response) => {
  const { eventName, date, trackId, speakerId } = req.query;
  const where: any = {};

  if (eventName) where.eventName = eventName;
  if (date) where.date = new Date(date as string);
  if (trackId) where.tracks = { some: { id: parseInt(trackId as string) } };
  if (speakerId)
    where.speakers = { some: { id: parseInt(speakerId as string) } };

  const sessions = await prisma.session.findMany({
    where,
    include: {
      tracks: true,
      speakers: true,
      subSessions: true,
    },
  });
  res.json(sessions);
});

/**
 * Endpoint to create a new sub-session
 * @param {Object} subSessionData - The sub-session data
 * @returns {SubSession} - The newly created sub-session
 */
app.post("/sub-sessions", async (req: Request, res: Response) => {
  const { parentSessionId, name, description, speakerIds } = req.body;

  try {
    const subSession = await prisma.subSession.create({
      data: {
        parentSessionId,
        name,
        description,
        speakers: {
          connect: speakerIds?.map((id: number) => ({ id })) || [],
        },
      },
      include: {
        speakers: true,
      },
    });
    res.json(subSession);
  } catch (error) {
    res.status(400).json({ error: "Failed to create sub-session" });
  }
});

/**
 * Endpoint to fetch all sub-sessions for a parent session
 * @param {string} parentSessionId - The ID of the parent session
 * @returns {SubSession[]} - All sub-sessions for the parent session
 */
app.get("/sub-sessions", async (req: Request, res: Response) => {
  const { parentSessionId } = req.query;
  const where: any = {};

  if (parentSessionId) {
    where.parentSessionId = parseInt(parentSessionId as string);
  }

  const subSessions = await prisma.subSession.findMany({
    where,
    include: {
      speakers: true,
    },
  });
  res.json(subSessions);
});

const port = process.env.PORT || 3000;

app.listen(port, () => {
  console.log(`🚀 Server ready at: http://localhost:${port}`);
});

module.exports = app;
