"""
This module fetches and processes data from various URLs to generate a manuf file.
"""

import re
import requests

# Define URLs
OUI_URL = "http://standards.ieee.org/develop/regauth/oui/oui.txt"
IAB_URL = "http://standards.ieee.org/develop/regauth/iab/iab.txt"
OUI36_URL = "http://standards.ieee.org/develop/regauth/oui36/oui36.txt"
CB_URL = "http://www.cavebear.com/archive/cavebear/Ethernet/Ethernet.txt"

# Define file paths
TEMPLATE_FILE = "C:/dev/projects/scripts/test-data/wireshark-ip-manufacturers/manuf.tmpl"
WKA_TEMPLATE_FILE = "C:/dev/projects/scripts/test-data/wireshark-ip-manufacturers/wka.tmpl"
OUTPUT_FILE = "C:/dev/projects/scripts/test-data/wireshark-ip-manufacturers/manuf"

# Regular expressions for matching OUI and manufacturer info
OUI_RE = r"([0-9A-Fa-f]{2})-([0-9A-Fa-f]{2})-([0-9A-Fa-f]{2})"
IEEE_RE = OUI_RE
CB_RE = r"([0-9A-Fa-f]{6})"

def shorten(manufacturer):
    """
	Shortens the manufacturer name by removing special characters, common words, and whitespace.

	Args:
		manufacturer (str): The manufacturer name to be shortened.

	Returns:
		str: The shortened manufacturer name.
	"""
    manufacturer = re.sub(r"[',.()/]", " ", manufacturer)
    manufacturer = re.sub(r"\s+&\s+", " ", manufacturer)
    manufacturer = re.sub(r"\s+(" +
        "the|inc|incorporated|plc|systems|corp|corporation|" +
        "s/a|a/s|ab|ag|kg|gmbh|co|company|limited|ltd|holding|spa)\\s",
        " ", manufacturer, flags=re.IGNORECASE)
    manufacturer = manufacturer.title()
    manufacturer = re.sub(r"\s+", "", manufacturer)
    return manufacturer[:8]

def fetch(url):
    """
    Fetches the content of the specified URL.

    Args:
        url (str): The URL to fetch the content from.

    Returns:
        str: The content of the URL.

    Raises:
        ValueError: If there is an error fetching the URL.
    """
    print(f"Fetching {url}.")
    response = requests.get(url, timeout=60)  # Add timeout argument
    if not response.ok:
        raise ValueError(f"Error fetching {url}: {response.text}")
    return response.text

def process_lists(urls):
    """
	Processes the lists of URLs to generate a dictionary of OUIs and manufacturers.

	Args:
		urls (list): The list of URLs to fetch the data from.

	Returns:
		dict: A dictionary of OUIs and manufacturers.
	"""
    oui_list = {}
    for url in urls:
        data = fetch(url)
        for line in data.split('\n'):
            if re.match(OUI_RE, line) or re.match(CB_RE, line):
                parts = line.split('\t', 1)
                if len(parts) == 2:
                    oui, manufacturer = parts
                    oui = re.sub('-', ':', oui).upper()
                    if oui not in oui_list:
                        oui_list[oui] = shorten(manufacturer)
    return oui_list

# Main function to generate the manuf file
def generate_manuf_file():
    """
	Generates the manuf file by processing the lists of URLs and writing the
	OUIs and manufacturers to the output file.
	"""
    oui_list = process_lists([OUI_URL, IAB_URL, OUI36_URL, CB_URL])
    with open(OUTPUT_FILE, 'w', encoding='utf-8') as out_file:
        with open(TEMPLATE_FILE, 'r', encoding='utf-8') as tmpl_file:
            for line in tmpl_file:
                out_file.write(line)
        with open(WKA_TEMPLATE_FILE, 'r', encoding='utf-8') as wka_file:
            for line in wka_file:
                out_file.write(line)
        for oui, manufacturer in sorted(oui_list.items()):
            out_file.write(f"{oui}\t{manufacturer}\n")


if __name__ == "__main__":
    generate_manuf_file()
