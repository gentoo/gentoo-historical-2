# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/log4cxx/log4cxx-0.10.0.ebuild,v 1.3 2009/03/13 02:21:03 jer Exp $

EAPI="1"

inherit eutils

MY_P="apache-${P}"

DESCRIPTION="Library of C++ classes for flexible logging to files, syslog and other destinations"
HOMEPAGE="http://logging.apache.org/log4cxx/"
SRC_URI="http://www.apache.org/dist/logging/${PN}/${PV}/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="doc iodbc unicode odbc smtp"

RDEPEND="dev-libs/apr:1
	dev-libs/apr-util:1
	odbc? (
		iodbc? ( >=dev-db/libiodbc-3.52.4 )
		!iodbc? ( dev-db/unixODBC ) )
	smtp? ( net-libs/libesmtp )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use iodbc && ! use odbc ; then
		elog "Please enable the odbc USE-flag as well if you want odbc-support through iodbc."
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${PV}-missing_includes.patch"
}

src_compile() {
	local myconf
	use smtp && myconf="${myconf} --with-SMTP=libesmtp"
	if use odbc ; then
		if use iodbc ; then
			myconf="${myconf} --with-ODBC=iODBC"
		else
			myconf="${myconf} --with-ODBC=unixODBC"
		fi
	fi
	use unicode && myconf="${myconf} --with-charset=utf-8"

	econf \
		--disable-doxygen \
		--disable-html-docs \
		${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "make install failed"
	dohtml -r site/*

	insinto /usr/share/doc/${PF}/examples
	doins src/examples/cpp/*.cpp
}
