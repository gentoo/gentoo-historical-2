# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/ruby/ruby-1.6.8-r2.ebuild,v 1.2 2003/10/31 17:14:32 usata Exp $

IUSE="ruby18"

inherit flag-o-matic alternatives eutils
filter-flags -fomit-frame-pointer

DESCRIPTION="An object-oriented scripting language"
HOMEPAGE="http://www.ruby-lang.org/"
SRC_URI="mirror://ruby/${PV%.*}/${P/_pre/-preview}.tar.gz"

LICENSE="Ruby"
SLOT="1.6"
KEYWORDS="x86 alpha ppc sparc hppa amd64 ia64"

DEPEND=">=sys-libs/glibc-2.1.3
	>=sys-libs/gdbm-1.8.0
	>=sys-libs/readline-4.1
	>=sys-libs/ncurses-5.2"

pkg_setup() {

	ewarn
	ewarn "If you have installed <dev-lang/ruby-1.6.8-r2 (ruby-1.6 branch) or"
	ewarn "<dev-lang/ruby-1.8.0-r1 (ruby-1.8 branch) please unmerge them first."
	ewarn "SLOT supports >=ruby-1.6.8-r2 and >=ruby-1.8.0-r1 only."
	ewarn
	einfo
	einfo "Also if you want to use ruby-1.8 by default you need to set"
	einfo "\tUSE=\"ruby18\""
	einfo "otherwise ruby-1.6 will be used."
	einfo

	echo -ne "\a" ; sleep 0.1 &>/dev/null ; sleep 0,1 &>/dev/null
	echo -ne "\a" ; sleep 1
	echo -ne "\a" ; sleep 0.1 &>/dev/null ; sleep 0,1 &>/dev/null
	echo -ne "\a" ; sleep 1
	echo -ne "\a" ; sleep 0.1 &>/dev/null ; sleep 0,1 &>/dev/null
	echo -ne "\a" ; sleep 1
	echo -ne "\a" ; sleep 0.1 &>/dev/null ; sleep 0,1 &>/dev/null
	echo -ne "\a" ; sleep 1
	echo -ne "\a" ; sleep 0.1 &>/dev/null ; sleep 0,1 &>/dev/null
	echo -ne "\a" ; sleep 1
	sleep 8
}

src_unpack() {
	unpack ${A}
	cd ${S}
	use amd64 && epatch ${FILESDIR}/ruby-1.6.8-fix-x86_64.patch
}

src_compile() {
	econf --program-suffix=16 --enable-shared || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	dosym /usr/lib/libruby16.so.${PV} /usr/lib/libruby.so.${PV%.*}
	dosym /usr/lib/libruby16.so.${PV} /usr/lib/libruby.so.${PV}

	dodoc COPYING* ChangeLog MANIFEST README* ToDo
}

ruby_alternatives() {
	if [ -n "`use ruby18`" ] ; then
		alternatives_makesym /usr/bin/ruby /usr/bin/ruby{18,16}
		alternatives_makesym /usr/bin/irb /usr/bin/irb{18,16}
		alternatives_makesym /usr/lib/libruby.so \
			/usr/lib/libruby{18,16}.so
		alternatives_makesym /usr/share/man/man1/ruby.1.gz \
			/usr/share/man/man1/ruby{18,16}.1.gz
	else
		alternatives_makesym /usr/bin/ruby /usr/bin/ruby{16,18}
		alternatives_makesym /usr/bin/irb /usr/bin/irb{16,18}
		alternatives_makesym /usr/lib/libruby.so \
			/usr/lib/libruby{16,18}.so
		alternatives_makesym /usr/share/man/man1/ruby.1.gz \
			/usr/share/man/man1/ruby{16,18}.1.gz
	fi
}

pkg_postinst() {
	ruby_alternatives
}

pkg_postrm() {
	ruby_alternatives
}
