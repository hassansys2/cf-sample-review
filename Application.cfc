component {
  this.name = "CFCodeTestApp";
  this.datasources = {
    cftest = {
      class: "com.mysql.cj.jdbc.Driver",
      connectionString: "jdbc:mysql://mysql:3306/cf_test_db",
      username: "root",
      password: "rootpassword"
    }
  };
} 