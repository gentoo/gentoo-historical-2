# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/IceRuby/IceRuby-3.3.1.ebuild,v 1.2 2009/11/19 14:36:59 fauli Exp $

inherit eutils

MY_P=${P/Ruby/}

DESCRIPTION="ICE middleware C++ bindings"
HOMEPAGE="http://www.zeroc.com/index.html"
SRC_URI="http://www.zeroc.com/download/Ice/3.3/${MY_P}.tar.gz"

S=${WORKDIR}/${MY_P}/rb

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="test debug"

RDEPEND="~dev-cpp/Ice-3.3.1
	>=dev-lang/ruby-1.8.6"

DEPEND="${RDEPEND}
	test? ( >=dev-lang/python-2.4 )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-Makefile.patch"

	MAKE_RULES="${S}/config/Make.rules"

	mkdir -p "${S}/bin"
	mkdir -p "${S}/lib"

	cp /usr/bin/slice2rb "${S}"/../cpp/bin

	if use amd64; then
		sed -i -e "s:^#LP64:LP64:g" "${MAKE_RULES}" \
		|| die "Failed to set lib64 directory"
	fi

	if ! use debug; then
		sed -i -e "s:#OPTIMIZE:OPTIMIZE:" \
		"${MAKE_RULES}" || die "Failed to remove debug"
	fi

#	sed -i -e \
#	"s:.*CXXFLAGS[^\+]*\=\s:CXXFLAGS = ${CXXFLAGS} :g" \
#	"${MAKE_RULES}.Linux" || die "CXXFLAGS patching failed!"
}

src_compile() {
	make depend
	emake || die "Died during make"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install Failed!"
}
