Feature: Get Gist endpoint

  Background:
    * url 'https://api.github.com/'

  Scenario: Get Gist for authenticated users

    * def accessToken = karate.read('classpath:accessToken.txt')
    * header Authorization = 'Bearer ' + accessToken
    * header Accept = 'application/vnd.github+json'
    Given path 'gists'

    When method GET
    Then status 200

  Scenario: Get Gist for authenticated users2

    * def accessToken = karate.read('classpath:accessToken.txt')
    Given path 'gists'
    And header Authorization = 'Bearer ' + accessToken
    And header Content-type =  'application/vnd.github+json'

    When method GET
    Then status 200