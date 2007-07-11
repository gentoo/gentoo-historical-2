# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/mysql++/mysql++-2.2.2-r1.ebuild,v 1.1 2007/07/11 10:18:58 robbat2 Exp $

inherit eutils gnuconfig

DESCRIPTION="C++ API interface to the MySQL database"
# This is the download page but includes links to other places
HOMEPAGE="http://www.mysql.org/downloads/api-mysql++.html"
SRC_URI="http://www.tangentsoft.net/mysql++/releases/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86 ~alpha ~hppa ~mips ~sparc ~ppc ~amd64"
IUSE=""

DEPEND=">=sys-devel/gcc-3"
RDEPEND="${DEPEND}
		>=virtual/mysql-4.0"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	for i in ${S}/lib/*.h ; do
		sed -i \
			-e '/#include </s,mysql.h,mysql/mysql.h,g' \
			-e '/#include </s,mysql_version.h,mysql/mysql_version.h,g' \
			"${i}" || die "Failed to sed ${i} for fixing MySQL includes"
	done
}

src_compile() {
	local myconf
	# we want C++ exceptions turned on
	myconf="--enable-exceptions"
	# give threads a try
	myconf="${myconf} --enable-thread-check"
	# not including the directives to where MySQL is because it seems to
	# find it just fine without

	# force the cflags into place otherwise they get totally ignored by
	# configure
	CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" \
	econf ${myconf} || die "econf failed"

	emake || die "unable to make"
}

src_install() {
	make DESTDIR="${D}" install || die
	# install the docs and HTML pages
	dodoc README* CREDITS ChangeLog HACKERS Wishlist
	dodoc doc/*
	cp -ra doc/html ${D}/usr/share/doc/${PF}/html
	prepalldocs
}
