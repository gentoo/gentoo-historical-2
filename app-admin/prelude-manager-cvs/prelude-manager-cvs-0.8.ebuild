# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/prelude-manager-cvs/prelude-manager-cvs-0.8.ebuild,v 1.1 2003/08/06 19:00:43 solar Exp $

inherit eutils

ECVS_SERVER="cvs.prelude-ids.org:/cvsroot/prelude"
ECVS_MODULE="prelude-manager"
ECVS_BRANCH="${ECVS_MODULE}-`echo ${PV} | sed s:\\\.:-:g`"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/${ECVS_MODULE}"

inherit cvs

S=${WORKDIR}/${ECVS_MODULE}

DESCRIPTION="Prelude-IDS Manager"
HOMEPAGE="http://www.prelude-ids.org"
# SRC_URI="http://www.prelude-ids.org/download/releases/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="ssl doc mysql postgres"
DEPEND="virtual/glibc
	dev-libs/libprelude-cvs
	ssl? ( dev-libs/openssl )
	doc? ( dev-util/gtk-doc )
	mysql? ( dev-db/mysql )
	postgres? ( dev-db/postgresql )"

RDEPEND="${DEPEND}"

src_compile() {
	local myconf
	export WANT_AUTOCONF_2_5="1"
	export WANT_AUTOMAKE_1_6="1"
	
	use ssl && myconf="${myconf} --enable-openssl" || myconf="${myconf} --enable-openssl=no"
	use doc && myconf="${myconf} --enable-gtk-doc" || myconf="${myconf} --enable-gtk-doc=no"
	use mysql && myconf="${myconf} --enable-mysql" || myconf="${myconf} --enable-mysql=no"
	use postgres && myconf="${myconf} --enable-postgresql" || myconf="${myconf} --enable-postgresql=no"
	
	aclocal -I /usr/share/aclocal
	autoconf
	autoheader
	libtoolize -c --force --ltdl --automake
	automake --gnu -a -c
	cd libltdl
	mv configure.in configure.in.tmp
	echo "AC_PREREQ(2.50)" > configure.in
	cat configure.in.tmp >> configure.in
	rm -f configure.in.tmp
	aclocal -I /usr/share/aclocal
	autoconf
	autoheader
	libtoolize -c --force --ltdl --automake
	automake --gnu -a -c
	cd ..
	econf ${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"

	# We skip start/stop scripts with the -cvs verison
	# If you want the scripts then use non -cvs 

	#insinto /etc/init.d
	#insopts -m 755
	#newins ${FILESDIR}/gentoo.init prelude-manager
	#insinto /etc/conf.d
	#insopts -m 644
	#newins ${FILESDIR}/gentoo.conf prelude-manager
}
