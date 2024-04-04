"""
	Here is some info about the ISO 8601 datetime format.
"""
from datetime import datetime
import re

def is_valid_iso8601_regex(date_string="2023-03-09T10:29:01.226141Z"):
    """
	Validates an ISO 8601 datetime string using regex
	An alternative regex to use instead of the one
	defined below is:
		r'^(-?(?:[1-9][0-9]*)?[0-9]{4})-(1[0-2]|0[1-9])-(3[01]|0[1-9]|[12][0-9])T(2[0-3]|[01][0-9]):([0-5][0-9]):([0-5][0-9])(\\.[0-9]+)?(Z|[+-](?:2[0-3]|[01][0-9]):[0-5][0-9])?$'

	Args:
		date_string: The string to validate.

	Returns:
		True if the string is a valid ISO 8601 datetime, False otherwise.
		Does not use built-in datetime module.
	"""
    regex = r'^\d{4}-\d{2}-\d{2}(T\d{2}:\d{2}:\d{2}(\.\d+)?(Z|[\+\-]\d{2}:\d{2})?)?$'
    return re.match(regex, date_string) is not None

def is_valid_iso8601_datetime(date_string="2023-03-09T10:29:01.226141Z"):
    """
	Validates an ISO 8601 datetime string using the

	Args:
		date_string: The string to validate.

	Returns:
		True if the string is a valid ISO 8601 datetime, False otherwise.
		Uses the built-in datetime module, which previously did not
		recognize the "Z" suffix as valid so we are replacing it.
		However, as of Python 3.6, datetime provides a fromisoformat
		function that handles "Z".
	"""
    try:
        datetime.fromisoformat(date_string)
    except ValueError:
        print(f'{date_string} is not a valid ISO 8601 datetime.')
        return False
    return True
