# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/root/root-3.03.04-r1.ebuild,v 1.9 2003/02/13 10:51:10 vapier Exp $

IUSE="mysql postgres opengl"

S=${WORKDIR}/${PN}
DESCRIPTION="An Object-Oriented Data Analysis Framework"
SRC_URI="ftp://root.cern.ch/root/root_v3.03.04.source.tar.gz"
HOMEPAGE="http://root.cern.ch/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 sparc "

DEPEND="virtual/x11
	>=media-libs/xpm-3.4k
	>=media-libs/freetype-2.0.9
	opengl? ( virtual/opengl virtual/glu )
	mysql? ( >=dev-db/mysql-3.23.49 )
	postgres? ( >=dev-db/postgresql-7.1.3-r4 )"

src_compile() {

	use opengl \
		&& myconf="${myconf} --enable-opengl" \
		|| myconf="${myconf} --disable-opengl"

	use mysql \
		&& myconf="${myconf} --enable-mysql" \
		|| myconf="${myconf} --disable-mysql"

	use postgres \
		&& myconf="${myconf} --enable-pgsql" \
		|| myconf="${myconf} --disable-pgsql"

	econf \
		linux \
		--docdir=/usr/share/doc/${P} \
		--enable-shared \
		--disable-rpath \
		--enable-thread \
		--enable-star \
		--enable-ttf \
		--disable-cern \
		--disable-sapdb \
		--disable-rfio \
		--disable-dcache \
		--disable-srp \
		--disable-afs \
		--disable-krb5 \
		--enable-shadowpw \
		--disable-pythia \
		--disable-pythia6 \
		--disable-venus \
		--enable-soversion \
		${myconf} || die "./configure failed"
	make || die
}

src_install () {
	make DESTDIR=${D} install || die
	
	dodir /etc/env.d
	echo "LDPATH=/usr/lib/root" > ${D}/etc/env.d/60root
}
