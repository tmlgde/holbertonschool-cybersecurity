#!/usr/bin/env python3
import asyncio
import aiohttp
from intel_broker import fetch_api


async def main():
    async with aiohttp.ClientSession() as session:
        # Cas 1 : serveur injoignable (le mock est éteint)
        r1 = await fetch_api(session, "http://localhost:5000/virustotal/1.2.3.4")
        print(r1)
        print(r1 == {"error": "Unavailable"})

        # Cas 2 : erreur HTTP 404 (page inexistante)
        r2 = await fetch_api(session, "http://localhost:8000/nexiste/pas")
        print(r2)
        print(r2 == {"error": "Unavailable"})


asyncio.run(main())
