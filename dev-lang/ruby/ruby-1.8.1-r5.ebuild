# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/ruby/ruby-1.8.1-r5.ebuild,v 1.2 2004/04/26 00:14:15 agriffis Exp $

IUSE="socks5 tcltk cjk"

ONIGURUMA="onigd2_2_6"
SNAP_DATE="20040424-1"

inherit flag-o-matic alternatives eutils gnuconfig
filter-flags -fomit-frame-pointer

DESCRIPTION="An object-oriented scripting language"
HOMEPAGE="http://www.ruby-lang.org/"
SRC_URI="mirror://ruby/${PV%.*}/${P/_pre/-preview}.tar.gz
	mirror://gentoo/${P}-${SNAP_DATE}.diff.gz
	cjk? ( ftp://ftp.ruby-lang.org/pub/ruby/contrib/${ONIGURUMA}.tar.gz )"

LICENSE="Ruby"
SLOT="1.8"
KEYWORDS="~amd64 ~alpha ~hppa -ia64 ~mips ~ppc ~sparc ~x86 ~s390"

DEPEND=">=sys-libs/glibc-2.1.3
	>=sys-libs/gdbm-1.8.0
	>=sys-libs/readline-4.1
	>=sys-libs/ncurses-5.2
	socks5? ( >=net-misc/dante-1.1.13 )
	tcltk?  ( dev-lang/tk )
	sys-apps/findutils
	>=dev-ruby/ruby-config-0.2"
RDEPEND="${DEPEND}
	!=dev-lang/ruby-cvs-${SLOT}*"
PROVIDE="virtual/ruby"

S=${WORKDIR}/${P%_pre*}

src_unpack() {
	unpack ${A}

	pushd ${S}
	epatch ../${P}-${SNAP_DATE}.diff
	popd

	if [ -n "`use cjk`" ] ; then
		einfo "Applying ${ONIGURUMA}"
		pushd ${WORKDIR}/oniguruma
		econf --with-rubydir=${S} || die "econf failed"
		make ${SLOT/./}
		popd
	fi

	# Enable build on alpha EV67
	if use alpha; then
		gnuconfig_update || die "gnuconfig_update failed"
	fi
}

src_compile() {
	# Socks support via dante
	if [ ! -n "`use socks5`" ] ; then
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
