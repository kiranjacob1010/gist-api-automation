Feature: Put Star Gist endpoint

  Background:
    * url 'https://api.github.com/'
    * def accessToken = karate.read('classpath:testData/accessToken.txt')


  Scenario: TC-1: Star a gist
    Given path 'gists/92332afe2ab249645b6f9596e536ca23/star'
    And header Authorization = 'Bearer ' + accessToken
    And header Content-type = 'application/vnd.github+json'
    When method put
    Then status 204


  Scenario: TC-2: Un Star a gist
    Given path 'gists/92332afe2ab249645b6f9596e536ca23/star'
    And header Authorization = 'Bearer ' + accessToken
    And header Content-type = 'application/vnd.github+json'
    When method delete
    Then status 204
