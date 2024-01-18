Feature: Get Gist endpoint

  Background:
    * url 'https://api.github.com/'
    * def accessToken = karate.read('classpath:testData/accessToken.txt')

  Scenario Outline: TC-01: Get Gist for authenticated user - with scenario <Scenario>
    Given path '/gists/<gistId>'
    And header Authorization = 'Bearer ' + accessToken
    When method get
    Then status <expectedStatus>
    And eval if (response.hasOwnProperty('public')) karate.match(response.public, <publicStatus>)
    Examples:
      | Scenario             | expectedStatus | gistId                           | publicStatus |
      | publicGist           | 200            | 2583488739d3e8f4c18a9f38bbb74dc0 | true         |
      | privateGist          | 200            | 3d0af6b148a576b9302eb7770cfbcf09 | false        |
      | nonExistingGist      | 404            | 8e8a62bbb36877f9c296b99a9f741743 | null         |

  Scenario: TC-02: Attempt to get a public Gist without authentication
    Given path '/gists/public'
    When method get
    Then status 200
    And match response[0].public == true

  Scenario: TC-03: Attempt to get a private Gist without authentication
    Given path '/gists/3d0af6b148a576b9302eb7770cfbcf09'
    And header Authorization = 'Bearer ' + 'invalidToken'
    When method get
    Then status 401

  Scenario: TC-06: Verify Gist content and structure
    Given path '/gists/8c9753b865e518c9d757702f13710246'
    And header Authorization = 'Bearer ' + accessToken
    When method get
    Then status 200
  #And match response.files.containsKey('file1.txt')
  #And match response.files['file1.txt'].content == 'This is the content of file1.txt'

  Scenario: TC-07: Verify Gist files and structure for a Gist with multiple files
    Given path '/gists/8c9753b865e518c9d757702f13710246'
    And header Authorization = 'Bearer ' + accessToken
    When method get
    Then status 200
  #And match response.files.containsKey('Kfile1.txt')
  #And match response.files.containsKey('Kfile2.txt')
  #And match response.files['Kfile1.txt'].content == 'hello one.txt'
  #And match response.files.Kfile2.txt.content == 'hello two.txt'
