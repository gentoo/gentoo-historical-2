# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/ruby/ruby-1.8.0-r7.ebuild,v 1.1 2004/08/19 13:25:12 usata Exp $

ONIGURUMA="onigd2_3_1"
MY_P=${P/_pre/-preview}

inherit flag-o-matic alternatives eutils gnuconfig

DESCRIPTION="An object-oriented scripting language"
HOMEPAGE="http://www.ruby-lang.org/"
SRC_URI="mirror://ruby/${PV%.*}/${P/_pre/-preview}.tar.gz
	cjk? ( http://www.geocities.jp/kosako1/oniguruma/archive/${ONIGURUMA}.tar.gz )"

LICENSE="Ruby"
SLOT="1.8"
KEYWORDS="~alpha ~hppa ~ia64 ~mips ~ppc ~sparc ~x86"
IUSE="socks5 tcltk cjk"

RDEPEND="virtual/libc
	>=sys-libs/gdbm-1.8.0
	>=sys-libs/readline-4.1
	>=sys-libs/ncurses-5.2
	socks5? ( >=net-misc/dante-1.1.13 )
	tcltk?  ( dev-lang/tk )
	>=dev-ruby/ruby-config-0.3
	!=dev-lang/ruby-cvs-1.8*"
DEPEND="sys-devel/autoconf
	sys-apps/findutils
	${RDEPEND}"
PROVIDE="virtual/ruby"

S=${WORKDIR}/${P%_pre*}

src_unpack() {
	unpack ${A}

	if use cjk ; then
		einfo "Applying ${ONIGURUMA}"
		pushd oniguruma
		econf --with-rubydir=${S} || die "econf failed"
		make ${SLOT/./}
		popd
	fi

	# Enable build on alpha EV67
	if [ "${ARCH}" = "alpha" ] ; then
		gnuconfig_update || die "gnuconfig_update failed"
	fi

	# bug #60525
	epatch ${FILESDIR}/${P}-CGI::Session.patch
}

src_compile() {
	filter-flags -fomit-frame-pointer

	# Socks support via dante
	if ! use socks5 ; then
		# Socks support can't be disabled as long as SOCKS_SERVER is
		# set and socks library is present, so need to unset
		# SOCKS_SERVER in that case.
		unset SOCKS_SERVER
	fi

	# Increase GC_MALLOC_LIMIT if set (default is 8000000)
	if [ -n "${RUBY_GC_MALLOC_LIMIT}" ] ; then
		CFLAGS="${CFLAGS} -DGC_MALLOC_LIMIT=${RUBY_GC_MALLOC_LIMIT}"
		export CFLAGS
	fi

	econf --program-suffix=${SLOT/./} --enable-shared \
		`use_enable socks5 socks` \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"

	dosym /usr/lib/libruby${SLOT/./}.so.${PV} /usr/lib/libruby.so.${PV%.*}
	dosym /usr/lib/libruby${SLOT/./}.so.${PV} /usr/lib/libruby.so.${PV}

	dodoc COPYING* ChangeLog MANIFEST README* ToDo
}

pkg_postinst() {
	ewarn
	ewarn "Warning: Vim won't work if you've just updated ruby from"
	ewarn "1.6.x to 1.8.x due to the library version change."
	ewarn "In that case, you will need to remerge vim."
	ewarn

	if [ ! -n "$(readlink ${ROOT}usr/bin/ruby)" ] ; then
		${ROOT}usr/sbin/ruby-config ruby${SLOT/./}
	fi
	einfo
	einfo "You can change the default ruby interpreter by ${ROOT}usr/sbin/ruby-config"
	einfo
}

pkg_postrm() {

	if [ ! -n "$(readlink ${ROOT}usr/bin/ruby)" ] ; then
		${ROOT}usr/sbin/ruby-config ruby${SLOT/./}
	fi
}
