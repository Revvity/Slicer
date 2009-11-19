#ifndef __qSlicerCLIModule_h
#define __qSlicerCLIModule_h

#include "qSlicerAbstractModule.h"

#include "qSlicerBaseQTCLIWin32Header.h"

class Q_SLICER_BASE_QTCLI_EXPORT qSlicerCLIModule : public qSlicerAbstractModule
{
  //Q_OBJECT

public:

  typedef qSlicerAbstractModule Superclass;
  qSlicerCLIModule(QWidget *parent=0);
  virtual ~qSlicerCLIModule();

  virtual void printAdditionalInfo();

  void setXmlModuleDescription(const char* xmlModuleDescription);

  virtual QString title()const;
  virtual QString category()const;
  virtual QString contributor()const;

  // Description:
  // Return help/acknowledgement text
  virtual QString helpText()const;
  virtual QString acknowledgementText()const;

  // Description:
  void setupUi();

protected:
  virtual void setup();

private:
  struct qInternal;
  qInternal* Internal;
};

#endif
