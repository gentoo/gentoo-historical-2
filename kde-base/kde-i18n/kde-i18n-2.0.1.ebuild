# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/kde-base/kde-i18n/kde-i18n-2.0.1.ebuild,v 1.1 2000/12/08 17:23:04 achim Exp $

A=${P}.tar.bz2
S=${WORKDIR}/${P}
DESCRIPTION="KDE 2Beta - Language Support"
SRC_PATH="kde/stable/${PV}/distribution/tar/generic/src/${A}"
SRC_URI="ftp://ftp.kde.org/pub/$SRC_PATH
	 ftp://ftp.sourceforge.net/pub/mirrors/$SRC_PATH"

HOMEPAGE="http://www.kde.org/"

DEPEND=">=kde-base/kdelibs-2.0.1"

src_unpack () {
  unpack ${A}
  cd ${S}
#  rm -r ca

}
src_compile() {
    cd ${S}
    rm catalog
    find /usr/share/sgml -name "catalog" -print -exec install-catalog -a catalog {} \;
    export SGML_CATALOG_FILES=${S}/catalog
    try ./configure --prefix=/opt/kde2 --host=${CHOST} \
		--with-qt-dir=/usr/lib/qt \
		--with-qt-includes=/usr/lib/qt/include \
		--with-qt-libs=/usr/lib/qt/lib
#    cp Makefile Makefile.orig
#    sed -e "s:^TOPSUBDIRS = .*:TOPSUBDIRS = ca cs da de el en_GB eo es et fi fr he hr hu is it mk nl no no_NY pl pt pt_BR ro ru sk sl sv ta tr uk:" Makefile.orig > Makefile
    try SGML_CATALOG_FILES=${S}/catalog make
}

src_install() {
  try make install DESTDIR=${D}
  dodoc COPYING highscore
  docinto html
  dodoc highscore.html
}



