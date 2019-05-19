\version "2.18.2"
#(set-global-staff-size 16)

\header {
  title = "Muck Pirates"
  subtitle = "mini game jams"
  composer = "Simon Symeonidis"
}


\score {
<<
  \new Staff \with {
    instrumentName = #"5str Bass"
    midiInstrument = #"electric bass (finger)"
  }
  {
    \clef bass
    \time 6/8
    \key e \minor

    \relative c {
      \mark "theme a"
      b'4 e,8 b'4 e,8 |
      e8 fis g fis g a |
      b4 e,8 b'4 e,8 |
      g fis e fis e d |

      b'4 e,8 b'4 e,8 |
      e8 fis g fis g a |
      b a g a g fis |
      g fis e fis e d | \bar "||"

      \mark "bassy groove"
      \repeat unfold 3 {
        e, e' e, e' e, e' |
        g, g' g, a a' a, |
        e, e' e, e' e, e' |
        g, g' g, d' d, d' |

        e e' e, e' e, e' |
        g, g' g, a a' a, |
        e, e' e, e' e, e' |
        g, g' g, d' d, d' |
      }

      \mark "develop theme"
      \repeat unfold 2 {
        e e' e, e' e, e' |
        g, g' g, a a' a, |
        e, e' e, e' e, e' |
        g, g' g, d' d, d' |

        e e' e, e' e, e' |
        g, g' g, a a' a, |
        e, e' e, e' e, e' |
        b' b' b, ais' ais, ais' |
      }
    }
  }

  \new Staff \with {
    instrumentName = #"flute"
    midiInstrument = #"flute"
  }
  {
    \key e \minor
    \clef treble
    \time 6/8

    \relative c' {
      \repeat unfold 4 {
        b'4 e,8 b'4 e,8 |
        e8 fis g fis g a |
        b4 e,8 b'4 e,8 |
        g fis e fis e d |

        b'4 e,8 b'4 e,8 |
        e8 fis g fis g a |
        b a g a g fis |
        g fis e fis e d |
      } \bar "||"

      %% lead theme
      e8 fis e fis4. |
      g4. a4. |
      e8 fis e fis4. |
      b4. ais4. |

      fis8 g a g a b |
      fis8 g a g a b |
      fis8 g a g a b |
      fis8 g a g a b |
    }
  }

  \new DrumStaff \with {
    instrumentName = #"Drums"
  } {
    \time 6/8

    \drummode {
      %% \repeat unfold 3 { <hh bd>16 hh hhho hh }
      %% <hh bd>16 hhho hhho hhho
      %% <cymch bd hh>8 hh <sn bd hh> hh <bd hh> hh <hh sn bd> hh |
      %% <bd hh>8 hh <sn bd hh> hh <bd hh> hh <hh sn bd> hh |
      %% <cymch bd hh>8 hh <sn bd hh> hh <bd hh> hh <hh sn bd> hh |
      %% <bd hh>8 hh <sn bd hh> hh <bd hh> hh <hh sn bd> hh |

      \repeat unfold 4 {
        <hhho bd>8 hh hh <hhho bd> hh hh |
        <hhho db>8 hh hh <hhho bd sn> <bd sn> <bd sn> |
      }

      \repeat unfold 6 {
        bd4. <bd sn cymch> |
        <bd sn>8 sn sn <bd hh sn> hh hh |
        bd4. <bd sn cymch> |
        <bd sn>8 sn sn <bd hh sn> hh hh |
      }

      \repeat unfold 4 {
        bd4. <bd sn cymch> |
        <bd sn>8 sn sn <bd hh sn> hh hh |
        bd4. <bd sn cymch> |
        <bd sn>8 sn sn <bd hh sn> hh hh |
      }
    }
  }
  >>

  \layout { }

  \midi {
    \tempo 4 = 180
  }
}