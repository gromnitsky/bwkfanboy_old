{
    "type": "object",
    "properties": {
		"channel": {
			"type": "object",
			"properties": {
				"updated": {
					"type": "string",
					"format": "date-time"
				},
				"id": { "type": "string" },
				"author": { "type": "string" },
				"title": { "type": "string" },
				"link": { "type": "string" },
				"x_entries_content_type": {
					"type": "string",
					"enum": ["text", "html", "xhtml"]
				}
			}
		},
		"x_entries": {
			"type": "array",
			"minItems": 1,
			"items": {
				"type": "object",
				"properties": {
					"title": { "type": "string" },
					"link": { "type": "string" },
					"updated": {
						"type": "string",
						"format": "date-time"
					},
					"author": { "type": "string" },
					"content": { "type": "string" }
				}
			}
		}
	}
}
