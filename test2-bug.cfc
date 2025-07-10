component {
	/**
	 * Retrieves user details from database
	 * @param userID The user ID to retrieve
	 * @param dsn The datasource name
	 * @return An array containing user details
	 */
	public array function getUserDetails(required numeric userID, required string dsn) {
		var qryUser = queryExecute("
			SELECT user_id
				, username
				, email
				, updated_at
			FROM users
			WHERE user_id = :userID
		", {
			userID: { value: arguments.userID, cfsqltype: "cf_sql_integer" }
		}, { datasource: arguments.dsn });

		var users = [];

		qryUser.forEach(function(row) {
			var userInfo = {};
			userInfo.userID = row.user_id;
			userInfo.username = row.username;
			userInfo.email = row.email;
			userInfo.lastUpdated = row.updated_at;

			arrayAppend(users, userInfo);
		});

		return users;
	}
}