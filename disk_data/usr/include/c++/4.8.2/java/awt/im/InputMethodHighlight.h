
// DO NOT EDIT THIS FILE - it is machine generated -*- c++ -*-

#ifndef __java_awt_im_InputMethodHighlight__
#define __java_awt_im_InputMethodHighlight__

#pragma interface

#include <java/lang/Object.h>
extern "Java"
{
  namespace java
  {
    namespace awt
    {
      namespace im
      {
          class InputMethodHighlight;
      }
    }
  }
}

class java::awt::im::InputMethodHighlight : public ::java::lang::Object
{

public:
  InputMethodHighlight(jboolean, jint);
  InputMethodHighlight(jboolean, jint, jint);
  InputMethodHighlight(jboolean, jint, jint, ::java::util::Map *);
  virtual jboolean isSelected();
  virtual jint getState();
  virtual jint getVariation();
  virtual ::java::util::Map * getStyle();
  static const jint RAW_TEXT = 0;
  static const jint CONVERTED_TEXT = 1;
  static ::java::awt::im::InputMethodHighlight * UNSELECTED_RAW_TEXT_HIGHLIGHT;
  static ::java::awt::im::InputMethodHighlight * SELECTED_RAW_TEXT_HIGHLIGHT;
  static ::java::awt::im::InputMethodHighlight * UNSELECTED_CONVERTED_TEXT_HIGHLIGHT;
  static ::java::awt::im::InputMethodHighlight * SELECTED_CONVERTED_TEXT_HIGHLIGHT;
private:
  jboolean __attribute__((aligned(__alignof__( ::java::lang::Object)))) selected;
  jint state;
  jint variation;
  ::java::util::Map * style;
public:
  static ::java::lang::Class class$;
};

#endif // __java_awt_im_InputMethodHighlight__
