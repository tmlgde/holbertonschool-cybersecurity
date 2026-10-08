#!/usr/bin/env python3
"""Test unitaire pour tester le sniffer sans réseau et sans root"""

import contextlib
import io
import unittest
from scapy.all import IP, TCP
from sniffer import TCPProcessor


class TestTCPProcessor(unittest.TestCase):
    """Classe de test pour TCP"""

    def test_extracts_ip_and_port(self) -> None:
        """Test direct du TCP"""
        pkt = IP(src="1.1.1.1")/TCP(dport=80)
        output = io.StringIO()
        with contextlib.redirect_stdout(output):
            TCPProcessor().process(pkt)
        result = output.getvalue()
        self.assertIn("1.1.1.1", result)
        self.assertIn(":80", result)


if __name__ == "__main__":
    unittest.main()
