import { __jacJsx, __jacSpawn } from "@jac-client/utils";
import { useState, useEffect } from "react";
import { Router, Routes, Route, Link } from "@jac-client/utils";
function Home() {
  return __jacJsx("div", {}, [__jacJsx("h1", {}, ["Home Page"]), __jacJsx("p", {}, ["Welcome to the home page!"])]);
}
function About() {
  return __jacJsx("div", {}, [__jacJsx("h1", {}, ["ℹ About Page"]), __jacJsx("p", {}, ["Learn more about our application."])]);
}
function Contact() {
  return __jacJsx("div", {}, [__jacJsx("h1", {}, ["Contact Page"]), __jacJsx("p", {}, ["Email: contact@example.com"])]);
}
function app() {
  return __jacJsx(Router, {}, [__jacJsx("div", {}, [__jacJsx("nav", {}, [__jacJsx(Link, {
    "to": "/"
  }, ["Home"]), " | ", __jacJsx(Link, {
    "to": "/about"
  }, ["About"]), " | ", __jacJsx(Link, {
    "to": "/contact"
  }, ["Contact"])]), __jacJsx(Routes, {}, [__jacJsx(Route, {
    "path": "/",
    "element": __jacJsx(Home, {}, [])
  }, []), __jacJsx(Route, {
    "path": "/about",
    "element": __jacJsx(About, {}, [])
  }, []), __jacJsx(Route, {
    "path": "/contact",
    "element": __jacJsx(Contact, {}, [])
  }, [])])])]);
}
export { About, Contact, Home, app };