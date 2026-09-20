# WebSocketNotifier

[![Ruby](https://img.shields.io/badge/ruby-3.0%2B-blue.svg)](https://www.ruby-lang.org/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Build Status](https://img.shields.io/github/actions/workflow/status/youruser/websocket_notifier/ruby.yml?branch=main)](https://github.com/youruser/websocket_notifier/actions)

WebSocketNotifier is a lightweight, production‑ready notification system built with Ruby, **Sinatra**, **Faye::WebSocket**, and **EventMachine**. 
It exposes a simple HTTP endpoint (`POST /notify`) that broadcasts arbitrary messages to all connected WebSocket clients in real time.

## Features

- ✅ Fully asynchronous WebSocket server
- ✅ Simple HTTP API for sending notifications
- ✅ Centralised configuration via `.env`
- ✅ Structured logging with configurable levels
- ✅ Comprehensive error handling
- ✅ Unit tests with Minitest
- ✅ Ready for Docker / CI pipelines

## Getting Started

### Prerequisites

- Ruby ≥ 3.0
- Bundler (`gem install bundler`)

### Installation