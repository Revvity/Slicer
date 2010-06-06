#ifndef __qSlicerIOOptions_h
#define __qSlicerIOOptions_h

/// QtCore includes
#include "qSlicerIO.h"
#include "qSlicerBaseQTCoreExport.h"

class Q_SLICER_BASE_QTCORE_EXPORT qSlicerIOOptions
{
public:  
  explicit qSlicerIOOptions(){}
  virtual ~qSlicerIOOptions(){}
  virtual qSlicerIO::IOProperties options()const;
};

#endif
