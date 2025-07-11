component {
	/**
	 * Retrieves user details from database
	 * @param userID The user ID to retrieve
	 * @param dsn The datasource name
	 * @return A struct containing user details
	 */
	public struct function getUserDetails(required numeric userID, required string dsn) {
		qryUser = queryExecute("
			SELECT user_id
				, username
				, email
				, updated_at
			FROM users
			WHERE user_id = :userID
		", {
			userID: { value: arguments.userID, cfsqltype: "cf_sql_integer" }
		}, { datasource: arguments.dsn });

		users = [];

		queryUser.forEach(function(row) {
			userInfo = {};
			userInfo.userID = user_id;
			userInfo.username = username;
			userInfo.email = email;
			userInfo.lastUpdated = updated_at;

			users.append(userInfo);
		});

		return users;
	}
}