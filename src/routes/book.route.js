import express from "express";
import { verifyAdmin } from "../middleware.js";
import {
  deleteBook,
  addBook,
  getBooks,
  updateQty,
  searchBook,
} from "../controllers/book.controller.js";

const router = express.Router();

router.post("/add", verifyAdmin, addBook);
router.put("/update/:id", verifyAdmin, updateQty);
router.delete("/remove/:id", verifyAdmin, deleteBook);

router.get("/", getBooks);
router.get("/search", searchBook);

export default router;
