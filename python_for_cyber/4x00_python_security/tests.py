#!/usr/bin/env python3
import unittest
from utils import validate_line, check_policy, hash_password

class TestBreachCheck(unittest.TestCase):
    """Classe qui teste toute la logique"""
    
    def test_validate_line_valid(self):
        """valide le format email:pwd"""
        self.assertTrue(validate_line("bob@gmail.com:password123"))


    def test_validate_line_invalid_format(self):
        """test l'invalidité du format"""
        self.assertFalse(validate_line("bob@gmail.com;password123"))


    def test_validate_line_missing(self):
        """test si il ne manque rien"""
        self.assertFalse(validate_line("password"))


    def test_check_policy_short_password(self):
        """test le check policy du pwd"""
        self.assertEqual(check_policy("abc", ["password", "1234"]), "WEAK")

    
    def test_check_policy_numeric_password(self):
        """test le numeric pwd"""
        self.assertEqual(check_policy("12345678", ["password", "1234567"]), "COMPLIANT")


    def test_check_policy__check_password(self):
        """test si un pwd est valide"""
        self.assertEqual(check_policy("xk9$mQ2p", ["password", "12345678"]), "COMPLIANT")


    def test_hash_password_deterministic(self):
        """meme password + meme salt -> meme hash"""
        h1 = hash_password("password123", "salt_abc")
        h2 = hash_password("password123", "salt_abc")
        self.assertEqual(h1, h2)


if __name__ == "__main__": unittest.main()
