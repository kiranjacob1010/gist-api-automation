@ignore
Feature: Delete Gist

  Background:
    * url 'https://api.github.com/'
    * def accessToken = karate.read('classpath:testData/accessToken.txt')

  @deleteGist
  Scenario: Delete Gist
    * def deleteGistId = karate.get('gistId')
    Given path '/gists/' + deleteGistId
    And header Authorization = 'Bearer ' + accessToken
    And header Content-type = 'application/vnd.github+json'
    When method DELETE
    Then status 204

  @createGist
  Scenario: Create Gist
    * def jsonBody = karate.read('classpath:testData/createGist.json')
    Given path '/gists'
    And header Authorization = 'Bearer ' + accessToken
    And header Content-type = 'application/vnd.github+json'
    And request jsonBody
    When method post
    Then status 201
    * def id = response.id
