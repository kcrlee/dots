return {
	"olimorris/codecompanion.nvim",
	lazy = true,
	opts = {
		strategies = {
			-- Change the default chat adapter
			chat = {
				adapter = "my_openai",
			},
		},
		opts = {
			-- Set debug logging
			log_level = "DEBUG",
		},
		show_defaults = false,
		adapters = {
			my_openai = function()
				return require("codecompanion.adapters").extend("openai_compatible", {
					env = {
						url = "http://127.0.0.1:1234", -- optional: default value is ollama url http://127.0.0.1:11434
						chat_url = "/v1/chat/completions", -- optional: default value, override if different
						models_endpoint = "/v1/models", -- optional: attaches to the end of the URL to form the endpoint to retrieve models
					},
					schema = {
						model = {
							default = "deepseek-r1-distill-qwen-7b", -- define llm model to be used
						},
						temperature = {
							order = 2,
							mapping = "parameters",
							type = "number",
							optional = true,
							default = 0.8,
							desc = "What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or top_p but not both.",
							validate = function(n)
								return n >= 0 and n <= 2, "Must be between 0 and 2"
							end,
						},
						max_completion_tokens = {
							order = 3,
							mapping = "parameters",
							type = "integer",
							optional = true,
							default = nil,
							desc = "An upper bound for the number of tokens that can be generated for a completion.",
							validate = function(n)
								return n > 0, "Must be greater than 0"
							end,
						},
						stop = {
							order = 4,
							mapping = "parameters",
							type = "string",
							optional = true,
							default = nil,
							desc = "Sets the stop sequences to use. When this pattern is encountered the LLM will stop generating text and return. Multiple stop patterns may be set by specifying multiple separate stop parameters in a modelfile.",
							validate = function(s)
								return s:len() > 0, "Cannot be an empty string"
							end,
						},
						logit_bias = {
							order = 5,
							mapping = "parameters",
							type = "map",
							optional = true,
							default = nil,
							desc = "Modify the likelihood of specified tokens appearing in the completion. Maps tokens (specified by their token ID) to an associated bias value from -100 to 100. Use https://platform.openai.com/tokenizer to find token IDs.",
							subtype_key = {
								type = "integer",
							},
							subtype = {
								type = "integer",
								validate = function(n)
									return n >= -100 and n <= 100, "Must be between -100 and 100"
								end,
							},
						},
					},
				})
			end,
		},
	},
}
