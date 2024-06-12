#!/usr/bin/env node
"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const bible = __importStar(require("./data/bibleChapters.json"));
const colors_1 = __importDefault(require("colors"));
const version = 'en-kjv';
// Getting Books
const bibleBooks = Object.keys(bible);
// Getting Random Number For Book. e.g. "0"
const randNumForBooks = Math.floor(Math.random() * bibleBooks.length);
// Actually Getting The Name of The Book. e.g. "genesis"
const book = bibleBooks[randNumForBooks];
// Getting Chapter
const chapter = Math.floor(Math.random() * bible[book]) + 1;
fetch(`https://cdn.jsdelivr.net/gh/wldeh/bible-api/bibles/${version}/books/${book.toLowerCase()}/chapters/${chapter}.json`)
    .then((response) => response.json())
    .then(({ data }) => {
    const versesSeen = new Set();
    const versesDeduped = data.filter(el => {
        const dupe = versesSeen.has(el.verse);
        versesSeen.add(el.verse);
        return !dupe;
    });
    console.log(colors_1.default.cyan.bold.underline(`Book: ${book} - Chapter: ${chapter}`));
    let verses = '';
    versesDeduped.forEach(({ verse, text }) => {
        verses += colors_1.default.red(`${verse}  `) + colors_1.default.green(`${text}\n`);
    });
    console.log(verses);
});
