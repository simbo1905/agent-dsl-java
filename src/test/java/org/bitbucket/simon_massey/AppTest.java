package org.bitbucket.simon_massey;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;

/// Unit test for simple App.
class AppTest {
    
    /// Test that demonstrates AssertJ usage
    @Test
    void shouldAnswerWithTrue() {
        assertThat(true).isTrue();
        assertThat("Hello World!").isNotBlank()
            .startsWith("Hello")
            .endsWith("World!")
            .contains("World");
    }
}
