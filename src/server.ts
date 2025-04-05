import express, { Request, Response } from "express";
import multer from "multer";
import { spawn } from "child_process";
import path from "path";
import fs from "fs";
import cors from "cors"; // Importamos cors

const app = express();
const port = process.env.PORT || 3000;

app.use(
  cors({
    origin: "*",
    methods: ["GET", "POST"],
    allowedHeaders: ["Content-Type"],
  })
);

const upload = multer({ dest: "uploads/" });

app.post("/convert", upload.single("file"), (req: any, res: any) => {
  const inputPath = req?.file?.path;

  if (!inputPath) {
    return res.status(400).send("No se ha subido ningún archivo");
  }

  const dcraw = spawn("dcraw", ["-c", inputPath]);
  const convert = spawn("convert", ["-", "jpg:-"]);

  dcraw.stdout.pipe(convert.stdin);

  res.setHeader("Content-Type", "image/jpeg");
  res.setHeader("Content-Disposition", "attachment; filename=converted.jpg");

  convert.stdout.pipe(res);

  dcraw.on("error", (error) => {
    console.error("Error al ejecutar dcraw:", error);
    res.status(500).send("Error al convertir el archivo");
  });

  convert.on("error", (error) => {
    console.error("Error al ejecutar convert:", error);
    res.status(500).send("Error al convertir el archivo");
  });

  dcraw.on("close", () => {
    fs.unlink(inputPath, () => {});
  });
});

app.get("/", (req, res) => {
  res.send("🚀 Servidor DNG to JPG corriendo!");
});

app.listen(port, () => {
  console.log(`Servidor corriendo en http://localhost:${port}`);
});
