#ifndef COORDINATESDATAMODEL_H
#define COORDINATESDATAMODEL_H

#include <QAbstractItemModel>
#include <QGeoCoordinate>

class CoordinatesDataModel : public QAbstractListModel {
    Q_OBJECT
public:
    enum Roles {
        CoordRole = Qt::UserRole + 1
    };

    CoordinatesDataModel(QObject* parent = nullptr);
    int rowCount(const QModelIndex& parent = QModelIndex()) const;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole);
    Q_INVOKABLE bool insertData(int row, const QVariant &value, const QModelIndex& parent = QModelIndex());
    Q_INVOKABLE bool removeRow(int row, const QModelIndex &parent = QModelIndex());
protected:
    QHash<int, QByteArray> roleNames() const;
private:
    QList<QGeoCoordinate> m_coords;
};



#endif // COORDINATESDATAMODEL_H
