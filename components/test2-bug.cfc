component {
	/**
	 * Retrieves user details from database
	 * @param userID The user ID to retrieve
	 * @param dsn The datasource name
	 * @return An array containing user details
	 */
	public array function getUserDetails(required numeric userID, required string dsn) {
		var qryUser = queryExecute("
			SELECT UserID
				, UserName
				, EmailAddress
				, updated_at
			FROM Users
			WHERE UserID = :userID
		", {
			userID: { value: arguments.userID, cfsqltype: "cf_sql_integer" }
		}, { datasource: arguments.dsn });

		var users = [];

		for (var i = 1; i <= qryUser.recordCount; i++) {
			var userInfo = {};
			userInfo.userID = qryUser.UserID[i];
			userInfo.username = qryUser.UserName[i];
			userInfo.email = qryUser.EmailAddress[i];
			userInfo.lastUpdated = qryUser.updated_at[i];

			arrayAppend(users, userInfo);
		}

		return users;
	}
}