# ColdFusion Code Test Project

This project contains three ColdFusion components that have been reviewed, fixed, and tested for various issues including SQL injection vulnerabilities, variable scope problems, case inconsistencies, and performance optimizations.

## Project Structure

```
CFCodeTest/
├── components/           # ColdFusion components
│   ├── test1-code_review.cfc
│   ├── test2-bug.cfc
│   ├── test3-performance.cfc
│   └── Application.cfc
├── tests/               # Test files
│   ├── test-runner.cfm
│   ├── unit-tests.cfm
│   ├── database-test.cfm
│   └── simple-test.cfm
├── database/            # Database initialization
│   └── init.sql
├── Dockerfile           # Lucee ColdFusion container
├── docker-compose.yml   # Docker orchestration
├── Application.cfc      # Application configuration
└── README.md           # This file
```

## Components

### 1. test1-code_review.cfc
- **Purpose**: User retrieval functions
- **Functions**: 
  - `getUserByID(userID, dsn)` - Retrieves user by ID
  - `getUserByUsername(username, dsn)` - Retrieves user by username
- **Fixes Applied**:
  - ✅ SQL injection protection using parameterized queries
  - ✅ Variable scope issues resolved
  - ✅ Case consistency fixed

### 2. test2-bug.cfc
- **Purpose**: User details retrieval
- **Functions**:
  - `getUserDetails(userID, dsn)` - Returns user details as array
- **Fixes Applied**:
  - ✅ Variable scope issues resolved
  - ✅ Database table/column name consistency fixed
  - ✅ Loop implementation optimized

### 3. test3-performance.cfc
- **Purpose**: Activity retrieval with user information
- **Functions**:
  - `getRecentActivitiesWithUsernames(maxActivities, dsn)` - Retrieves activities with usernames
- **Fixes Applied**:
  - ✅ N+1 query problem resolved with JOIN
  - ✅ Performance optimization implemented
  - ✅ Proper null handling for missing users

## Test Results

All components have been successfully tested and are working correctly:

### ✅ Security Tests
- SQL injection protection verified
- Parameterized queries implemented
- Malicious input handling tested

### ✅ Functionality Tests
- All functions execute without errors
- Proper data types returned
- Database connectivity confirmed

### ✅ Performance Tests
- Query execution times under 5ms
- N+1 query problem resolved
- Efficient JOIN operations implemented

### ✅ Code Quality Tests
- Variable scope issues resolved
- Case consistency fixed
- Syntax validation passed

## Running the Tests

The project includes a Docker-based testing environment with Lucee ColdFusion and MySQL.

### Prerequisites
- Docker
- Docker Compose

### Automated Testing (Recommended)

The project includes several automation scripts for different testing scenarios:

#### 🚀 **Complete Build and Test** (`build-and-test.sh`)
```bash
./build-and-test.sh
```
- **Purpose**: Full build, test, and optional cleanup
- **Features**: 
  - ✅ Builds containers from scratch
  - ✅ Runs comprehensive test suite
  - ✅ Asks user if they want to keep containers running
  - ✅ Perfect for development and debugging
- **Use Case**: When you want control over container lifecycle

#### 🤖 **Fully Automated** (`build-test-cleanup.sh`)
```bash
./build-test-cleanup.sh
```
- **Purpose**: Complete automation with automatic cleanup
- **Features**:
  - ✅ Builds containers from scratch
  - ✅ Runs comprehensive test suite
  - ✅ Automatically cleans up everything (no prompts)
  - ✅ Perfect for CI/CD pipelines
- **Use Case**: When you want guaranteed clean state

#### ⚡ **Quick Testing** (`quick-test.sh`)
```bash
./quick-test.sh
```
- **Purpose**: Fast tests on already running containers
- **Features**:
  - ✅ Very fast execution (no building/starting)
  - ✅ Requires containers to be already running
  - ✅ Perfect for development iterations
- **Use Case**: When containers are already running and you want quick validation

#### 🧹 **Manual Cleanup** (`cleanup.sh`)
```bash
./cleanup.sh
```
- **Purpose**: Clean up containers and resources
- **Features**:
  - ✅ Stops and removes all containers
  - ✅ Cleans up volumes and networks
  - ✅ Removes dangling images
- **Use Case**: When you want to manually clean up resources

### 📊 **Script Comparison**

| Feature | build-and-test.sh | build-test-cleanup.sh | quick-test.sh | cleanup.sh |
|---------|-------------------|----------------------|----------------|------------|
| **Container Building** | ✅ Yes | ✅ Yes | ❌ No | ❌ No |
| **Container Starting** | ✅ Yes | ✅ Yes | ❌ No | ❌ No |
| **Test Execution** | ✅ Yes | ✅ Yes | ✅ Yes | ❌ No |
| **User Prompts** | ✅ Yes | ❌ No | ❌ No | ❌ No |
| **Auto Cleanup** | Optional | ✅ Yes | ❌ No | ✅ Yes |
| **Speed** | 🐌 Slower | 🐌 Slower | ⚡ Very Fast | ⚡ Fast |
| **Use Case** | Development | CI/CD | Iterations | Cleanup |

### 🎯 **Recommended Workflows**

#### **For Development:**
```bash
# First time setup
./build-and-test.sh

# During development (keep containers running)
./quick-test.sh
./quick-test.sh
./quick-test.sh
# ... iterate quickly

# When done
./cleanup.sh
```

#### **For CI/CD Pipelines:**
```bash
# Every time (guaranteed clean state)
./build-test-cleanup.sh
```

#### **For Quick Validation:**
```bash
# Start containers once
docker-compose up -d

# Run quick tests multiple times
./quick-test.sh
./quick-test.sh
./quick-test.sh

# Clean up when done
./cleanup.sh
```

### Manual Testing
```bash
# Start the containers
docker-compose up -d

# Wait for containers to be ready (about 30 seconds)
sleep 30

# Run comprehensive tests
curl http://localhost:8080/tests/test-runner.cfm

# Run unit tests
curl http://localhost:8080/tests/unit-tests.cfm

# Run simple validation tests
curl http://localhost:8080/tests/simple-test.cfm
```

### 🤔 **Which Script Should I Use?**

#### **Choose `build-and-test.sh` if:**
- You want to build containers from scratch
- You want control over whether containers stay running
- You're doing development work and might need to debug
- You want to see detailed progress and status

#### **Choose `build-test-cleanup.sh` if:**
- You want fully automated testing (no user interaction)
- You're setting up CI/CD pipelines
- You want guaranteed clean state after testing
- You don't need containers running after tests

#### **Choose `quick-test.sh` if:**
- Containers are already running
- You want very fast test execution
- You're doing iterative development
- You want to run tests multiple times quickly

#### **Choose `cleanup.sh` if:**
- You want to manually clean up resources
- You're done with testing and want to free up system resources
- You want to start fresh for the next test run

## Database Schema

The test database includes:
- **Users** table with UserID, UserName, EmailAddress, created_at, updated_at
- **Activities** table with ActivityID, UserID, ActivityType, ActivityDate

Sample data is automatically populated during container initialization.

## Technical Details

- **ColdFusion Engine**: Lucee 5.4.8.2
- **Database**: MySQL 8.0
- **Web Server**: Apache Tomcat
- **Port**: 8080 (mapped from container port 8888)

## Test Coverage

The test suite covers:
1. **Component Compilation** - All components load successfully
2. **Function Signatures** - Parameter validation and return types
3. **Security** - SQL injection protection
4. **Performance** - Query optimization and execution times
5. **Data Integrity** - Proper data retrieval and formatting
6. **Error Handling** - Graceful handling of edge cases

All tests are currently **PASSING** ✅ 