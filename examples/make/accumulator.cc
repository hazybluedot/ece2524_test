#include "accumulator.hpp"

void Accumulator::increment(const double v) {
    m_value += v;
}

double Accumulator::get() const {
    return m_value;
}
