
import com.intuit.karate.junit5.Karate;

public class KarateRunner {

    @Karate.Test
    Karate testRunner() {
        return Karate.run("classpath:features");
    }
}