// patterns_seed.mqh
#pragma once

// This seed file demonstrates how to load a small set of patterns into the CPatternRecognizer.
// For production replace the ProvidePatternSeed() contents with your historical 500-pattern dataset.

void ProvidePatternSeed(CPatternRecognizer &pr)
  {
   // Example: add 12 synthetic but varied patterns with pseudo win rates.
   double p1[20] = {0.1,0.12,0.11,0.09,0.08,0.07,0.05,0.04,0.02,0.01,0.0,-0.01,-0.02,-0.03,-0.02,-0.01,0.0,0.01,0.02,0.03};
   double p2[20] = {-0.1,-0.12,-0.11,-0.09,-0.08,-0.07,-0.05,-0.04,-0.02,-0.01,0.0,0.01,0.02,0.03,0.02,0.01,0.0,-0.01,-0.02,-0.03};
   double p3[20] = {0.0,0.01,0.0,0.02,0.01,0.0,-0.01,-0.02,-0.01,0.0,0.02,0.03,0.04,0.05,0.04,0.03,0.02,0.01,0.0,-0.01};
   double p4[20] = {0.2,0.18,0.17,0.15,0.12,0.1,0.09,0.08,0.06,0.04,0.02,0.0,-0.01,-0.02,-0.01,0.0,0.01,0.02,0.03,0.04};
   double p5[20] = {-0.2,-0.18,-0.17,-0.15,-0.12,-0.1,-0.09,-0.08,-0.06,-0.04,-0.02,0.0,0.01,0.02,0.01,0.0,-0.01,-0.02,-0.03,-0.04};

   pr.AddPattern(p1,0.75);
   pr.AddPattern(p2,0.7);
   pr.AddPattern(p3,0.65);
   pr.AddPattern(p4,0.8);
   pr.AddPattern(p5,0.45);

   // NOTE: Replace the above with your 500-pattern dataset. You can generate a .mqh file with an
   // array literal for all patterns, or implement a loader to read patterns from GlobalVariables or a file.
  }
