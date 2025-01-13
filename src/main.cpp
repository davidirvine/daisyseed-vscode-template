#include "daisy_seed.h"

daisy::DaisySeed hardware;

int main(void)
{
    bool led_state;
    led_state = true;

    // Configure and Initialize the Daisy Seed
    // These are separate to allow reconfiguration of any of the internal
    // components before initialization.
    hardware.Configure();
    hardware.Init();

    // HEADS UP! StartLog will block until a serial terminal is connected
    hardware.StartLog(true);
    hardware.PrintLine("DaisyVSCodeTemplate Initialized");
    
    // Loop forever
    for(;;)
    {
        // Set the onboard LED
        hardware.SetLed(led_state);

        // Toggle the LED state for the next time around.
        led_state = !led_state;

        // Wait 500ms
        daisy::System::Delay(500);
    } 
}