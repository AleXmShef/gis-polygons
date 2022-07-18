#include "CoordinatesDataModel.h"

CoordinatesDataModel::CoordinatesDataModel(QObject *parent) : QAbstractListModel(parent)
{
}

int CoordinatesDataModel::rowCount(const QModelIndex& parent) const {
    Q_UNUSED(parent);
    return m_coords.count();
}

QVariant CoordinatesDataModel::data(const QModelIndex & index, int role) const {
    if (index.row() < 0 || index.row() >= m_coords.count())
        return QVariant();

    auto& coord = m_coords[index.row()];
    return QVariant::fromValue(coord);
}

bool CoordinatesDataModel::setData(const QModelIndex &index, const QVariant &value, int role) {
    if (index.row() < 0 || index.row() >= m_coords.count())
        return false;
    m_coords[index.row()] = value.value<QGeoCoordinate>();
    emit dataChanged(index, index);
    return true;
}

bool CoordinatesDataModel::insertData(int row, const QVariant &value, const QModelIndex& parent) {
    if (row < 0 || row > m_coords.count())
        return false;
    beginInsertRows(parent, row, row);
    auto coord = value.value<QGeoCoordinate>();
    m_coords.insert(row, coord);
    endInsertRows();
    return true;
}

bool CoordinatesDataModel::removeRow(int row, const QModelIndex &parent) {
    if (row < 0 || row >= m_coords.count())
        return false;
    beginRemoveRows(parent, row, row);
    m_coords.removeAt(row);
    endRemoveRows();
    return true;
}

QHash<int, QByteArray> CoordinatesDataModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[CoordRole] = "coord";
    return roles;
}


