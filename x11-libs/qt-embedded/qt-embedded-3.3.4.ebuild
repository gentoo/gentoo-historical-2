# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt-embedded/qt-embedded-3.3.4.ebuild,v 1.1 2005/02/23 11:12:01 greg_g Exp $

DESCRIPTION="Embedded Linux port of Qt"
HOMEPAGE="http://www.trolltech.com/products/embedded/"
SRC_URI="ftp://ftp.trolltech.com/qt/source/qt-embedded-free-${PV}.tar.bz2"
LICENSE="|| ( QPL-1.0 GPL-2 )"

SLOT="3"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE="cups debug doc firebird gif ipv6 mysql nis odbc opengl postgres sqlite"

DEPEND="media-libs/libpng
	media-libs/jpeg
	media-libs/libmng
	media-libs/lcms
	sys-libs/zlib
	cups? ( net-print/cups )
	odbc? ( >=dev-db/unixODBC-2 )
	firebird? ( dev-db/firebird )
	mysql? ( dev-db/mysql )
	opengl? ( virtual/opengl virtual/glu )
	postgres? ( dev-db/postgresql )"

S=${WORKDIR}/qt-embedded-free-${PV}

QTBASE=/usr/qt/3-embedded

pkg_setup() {
	ewarn "Note: this ebuild provides a Qt/Embedded setup that is suitable for testing,"
	ewarn "but definitely not tailored for real embedded systems."
	ewarn "I advise you select your own featureset (e.g. by editing this ebuild)"
	ewarn "if building for such a system."

	export QTDIR=${S}

	# values for 'PLATFORM' (host system) can be found in mkspecs/
	# values for 'XPLATFORM' (target system) can be found in mkspecs/qws/
	if use x86; then
		export PLATFORM="linux-g++"
		export XPLATFORM="qws/linux-x86-g++"
	elif use amd64; then
		export PLATFORM="linux-g++-64"
		export XPLATFORM="qws/linux-x86-g++"
	elif use ppc; then
		export PLATFORM="linux-g++"
		export XPLATFORM="qws/linux-generic-g++"
	else
		die "Unknown platform"
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}

	sed -i -e 's:read acceptance:acceptance=yes:' configure

	# avoid using -rpath
	find mkspecs/ -name qmake.conf -exec sed -i -e "s:QMAKE_RPATH.*:QMAKE_RPATH =:" {} \;
}

src_compile() {
	addwrite "${QTBASE}/etc/settings"

	use gif && myconf="${myconf} -qt-gif" || myconf="${myconf} -no-gif"
	use cups && myconf="${myconf} -cups" || myconf="${myconf} -no-cups"
	use nis && myconf="${myconf} -nis" || myconf="${myconf} -no-nis"
	use ipv6 && myconf="${myconf} -ipv6" || myconf="${myconf} -no-ipv6"
	use opengl || myconf="${myconf} -disable-opengl"
	use mysql && myconf="${myconf} -plugin-sql-mysql -I/usr/include/mysql -L/usr/lib/mysql" || myconf="${myconf} -no-sql-mysql"
	use postgres && myconf="${myconf} -plugin-sql-psql -I/usr/include/postgresql/server -I/usr/include/postgresql/pgsql -I/usr/include/postgresql/pgsql/server" || myconf="${myconf} -no-sql-psql"
	use odbc && myconf="${myconf} -plugin-sql-odbc" || myconf="${myconf} -no-sql-odbc"
	use firebird && myconf="${myconf} -plugin-sql-ibase" || myconf="${myconf} -no-sql-ibase"
	use sqlite && myconf="${myconf} -plugin-sql-sqlite" || myconf="${myconf} -no-sql-sqlite"
	use debug && myconf="${myconf} -debug" || myconf="${myconf} -release -no-g++-exceptions"

	./configure ${myconf} -shared -depths 8,16,24,32 -system-zlib -thread -stl \
		-freetype -qvfb -plugin-imgfmt-{jpeg,mng,png} -system-lib{jpeg,mng,png} \
		-prefix ${QTBASE} -platform ${PLATFORM} -xplatform ${XPLATFORM} \
		-embedded || die

	export LD_LIBRARY_PATH="${S}/lib:${LD_LIBRARY_PATH}"

	cd ${S} && emake symlinks src-qmake src-moc sub-src || die "make failed"

	# the designer is not compiled when using -embedded, but we need the uic
	cd ${S}/tools/designer/uic && emake || die "making uic failed"

	cd ${S} && emake sub-tools || die "making tools failed"

	if use doc; then
		cd ${S} && emake sub-tutorial sub-examples || die "making examples failed"
	fi
}

src_install() {
	INSTALL_ROOT=${D} emake install

	# fix .prl files
	find ${D}/${QTBASE}/lib* -name "*.prl" -exec sed -i -e "s:${S}:${QTBASE}:g" {} \;

	# remove broken link
	rm -f ${D}/${QTBASE}/mkspecs/${PLATFORM}/${PLATFORM}

	# fonts
	insinto ${QTBASE}/lib/fonts
	doins ${S}/lib/fonts/*

	# environment variables
	cat <<EOF > ${T}/47qt-embedded3
PATH=${QTBASE}/bin
ROOTPATH=${QTBASE}/bin
LDPATH=${QTBASE}/lib
EOF
	insinto /etc/env.d
	doins ${T}/47qt-embedded3

	# qmake cache file
	sed -i -e "s:${S}:${QTBASE}:" .qmake.cache
	insinto ${QTBASE}
	doins .qmake.cache

	# documentation
	if use doc; then
		find examples tutorial -name Makefile -exec sed -i -e "s:${S}:${QTBASE}:g" {} \;

		cp -r ${S}/tutorial ${D}/${QTBASE}
		cp -r ${S}/examples ${D}/${QTBASE}
	fi

	# default target link (overriden by QMAKESPEC env var)
	rm -f "${D}/${QTBASE}/mkspecs/default"
	ln -s "${XPLATFORM}" "${D}/${QTBASE}/mkspecs/default"
}

pkg_postinst() {
	echo
	einfo "If you want to compile and run a test application using"
	einfo "QT/Embedded instead of standard Qt, you must properly"
	einfo "set the QTDIR and QMAKESPEC variables, e.g.:"
	einfo ""
	einfo "    export QTDIR=${QTBASE}"
	einfo "    export QMAKESPEC=${QTBASE}/mkspecs/${XPLATFORM}"
	echo
}
