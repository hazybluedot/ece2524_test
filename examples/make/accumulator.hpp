#ifndef _ACCUMULATOR_HPP_
#define _ACCUMULATOR_HPP_

class Accumulator {
public:
    Accumulator(const double init=0) : m_value(init) {};

    void increment(const double v=1);
    double get() const;
private:
    double m_value;
};

#endif
