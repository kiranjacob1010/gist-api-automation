Feature: Create Gist

  Background:
    * url 'https://api.github.com/'
    * def accessToken = karate.read('classpath:testData/accessToken.txt')

  Scenario: TC-01: Create a new Gist with data
    Given path '/gists'
    And request
    """
    {
      "files": {
        "file1": {
          "content": "This is the content of file1.txt"
        }
      },
      "public": true,
      "description": "Testcase for a gist creation"
    }
    """
    And header Authorization = 'Bearer ' + accessToken
    And header Content-type = 'application/vnd.github+json'
    When method post
    Then status 201
    And match response.public == true
    And match response.files.file1.truncated == false

  Scenario: TC-02: Create a gist with a large payload exceeding 10mb
    * def payload = karate.read('classpath:testData/highPayload10Mb.txt')
    * def jsonBody = karate.read('classpath:testData/createGist.json')
    Given jsonBody.files.gistTest.content = payload
    Given path 'gists'
    And header Authorization = 'Bearer ' + accessToken
    And header Content-type = 'application/vnd.github+json'
    And request jsonBody
    When method post
    Then status 201
    And match response.files.gistTest.truncated == true

  Scenario: TC-03: Create a gist with missing data
    Given path 'gists'
    And request
    """
    {
      "description": "no payload given",
      "public": true,
      "files": {}
    }
    """
    And header Authorization = 'Bearer ' + accessToken
    And header Content-type = 'application/vnd.github+json'
    When method post
    Then status 422

  Scenario: TC-04: Create a gist with missing content
    Given path 'gists'
    And request
    """
    {
      "description": "no payload given",
      "public": true,
      "files": {"content": ""}
    }
    """
    And header Authorization = 'Bearer ' + accessToken
    And header Content-type = 'application/vnd.github+json'
    When method post
    Then status 422

  Scenario: TC-05: Create a new Gist with content as special characters
    Given path '/gists'
    And header Authorization = 'Bearer ' + accessToken
    And header Content-type = 'application/vnd.github+json'
    And request
    """
    {
      "files": {
        "file4.txt": {
          "content": "=)(///€@@³³³³§§$%&µµµµµµµ$§$$$$$$$$$$$$$$$%%%%%%%%%%%%%%%§§§§§§§§§§§§§§§§€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€<-----<<<<<<<<,,,,."
        }
      },
      "public": true,
      "description": "Testcase for a gist creation"
    }
    """
    When method post
    Then status 201

  Scenario: TC-06: Create Gist with multiple files
    Given path '/gists'
    And request
    """
    {
      "files": {
        "Kfile1.txt": {
          "content": "hello one.txt"
        },
        "Kfile2.txt": {
          "content": "hello two.txt"
        },
        "Kfile3.txt": {
          "content": "hello three.txt"
        }
      },
      "public": true,
      "description": "Test Gist with 3 files"
    }
    """
    And header Authorization = 'Bearer ' + accessToken
    And header Content-type = 'application/vnd.github+json'
    When method post
    Then status 201
  # And match response.public == true
  # And match response.files contains  {"Kfile1.txt": { "content": "hello one.txt" }}
  # And print 'Request:', request
  # And print 'Response:', response
