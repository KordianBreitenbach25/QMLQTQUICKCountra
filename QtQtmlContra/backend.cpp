#include "backend.h"

Backend::Backend(QObject *parent)
    : QObject{parent}
{

}

void Backend::generateNumber(int min, int max)
{
    const int mini=0;
    const int maxi=3;
    emit numberEmitted(mini,maxi);
}
