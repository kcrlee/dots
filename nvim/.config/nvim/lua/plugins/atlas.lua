vim.pack.add({
	"https://github.com/emrearmagan/atlas.nvim",
})

require("atlas").setup({
	providers = {
		---@type AtlasGitHubConfig
		github = {
			hostname = "github.com",
			cache_ttl = 300, -- Seconds; 0 disables caching.
		},
	},
	issues = {
		---@type AtlasGitHubIssuesConfig
		github = {
			---@type AtlasGitHubIssuesViewConfig[]
			views = {
				{
					name = "Assigned",
					key = "1",
					layout = "plain",
					-- current_repo = true, -- Limit this view to the local repository.
					search = "assignee:@me is:open",
				},
				{
					name = "Created",
					key = "2",
					layout = "compact",
					search = "author:@me is:open",
				},
				{
					name = "Mentions",
					key = "3",
					layout = "plain",
					search = "mentions:@me is:open",
				},
			},

			bookmarks = {
				key = "S", -- default
				label = "Search", -- default
				items = {
					["Bugs"] = "is:issue is:open label:bug",
					["Recently closed"] = "is:issue is:closed author:@me sort:updated-desc",
				},
			},
		},
	},
	---@type AtlasPullsConfig
	pulls = {
		---@type AtlasGitHubPullsConfig
		github = {
			views = {
				{
					name = "Assigned",
					key = "1",
					layout = "compact", -- "compact" | "grouped" | "plain"
					-- current_repo = true, -- Restrict the search to the current Git repository.
					search = "is:pr assignee:@me archived:false",
				},
				{ name = "Authored", key = "2", search = "is:pr author:@me archived:false" },
				{ name = "Reviewing", key = "3", search = "is:pr review-requested:@me archived:false" },
				{ name = "Reviewed", key = "4", search = "is:pr reviewed-by:@me archived:false" },
				{ name = "Mention", key = "5", search = "is:pr mentions:@me archived:false" },
			},
			bookmarks = {
				-- key   = "S",      -- default
				-- label = "Search", -- default
				items = {
					["Drafts"] = {
						layout = "compact",
						search = "is:pr is:draft author:@me",
					},
					["Recently merged"] = "is:pr is:merged author:@me sort:updated-desc",
				},
			},
		},
	},
	description = {
		include_summary = true,
		include_commit_hashes = true,
		include_related = true,
		include_diffstat = false,
	},
	diff = {
		open_cmd = "auto",
		comment_display = "virtual_lines",
	},

	lsp = {
		enabled = true,
		dir = nil,
		link = {},
	},
	---@type AtlasPullsDiffExplorerConfig
	explorer = {
		grouped = true, -- Group changed files by directory.
		hidden = false,
		show_commits = false, -- Set true to show commits below changed files initially.
		width = 40,
		initial_focus = "explorer", -- "explorer" or "diff".
		preview = false, -- Show a file as soon as the explorer cursor moves onto it.
		focus_on_select = false, -- Move into the diff after selecting a file.
		ignore = { ".git/**", ".jj/**" },
	},
})
