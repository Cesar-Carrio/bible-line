#!/usr/bin/env node
import * as bible from "./data/bibleChapters.json";
import colors from "colors";

type BibleBooks = keyof typeof bible;
type BibleResponse = {
  book: BibleBooks;
  chapter: number;
  verse: number;
  text: string;
};

const version = 'en-kjv';

// Getting Books
const bibleBooks: BibleBooks[] = Object.keys(bible) as BibleBooks[];
// Getting Random Number For Book. e.g. "0"
const randNumForBooks: number = Math.floor(Math.random() * bibleBooks.length);
// Actually Getting The Name of The Book. e.g. "genesis"
const book: BibleBooks = bibleBooks[randNumForBooks];
// Getting Chapter
const chapter: number = Math.floor(Math.random() * bible[book]) + 1;


fetch(
  `https://cdn.jsdelivr.net/gh/wldeh/bible-api/bibles/${version}/books/${book.toLowerCase()}/chapters/${chapter}.json`)
  .then((response) => response.json())
  .then(({ data }: { data: [BibleResponse]}) => {
    const versesSeen = new Set();
    const versesDeduped = data.filter(el => {
      const dupe = versesSeen.has(el.verse);
      versesSeen.add(el.verse);
      return !dupe;
    }); 

    console.log(colors.cyan.bold.underline(`Book: ${book} - Chapter: ${chapter}`))
    let verses = '';
    versesDeduped.forEach(({verse, text}: BibleResponse) => {
      verses += colors.red(`${verse}  `) + colors.green(`${text}\n`);
    });

    console.log(verses);
  });
