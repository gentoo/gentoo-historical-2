# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/canna/canna-3.6_p3-r2.ebuild,v 1.4 2003/08/05 15:39:29 vapier Exp $

inherit eutils

MY_P="Canna36p3"

DESCRIPTION="A client-server based Kana-Kanji conversion system"
HOMEPAGE="http://canna.sourceforge.jp/"
SRC_URI="http://downloads.sourceforge.jp/canna/2181/${MY_P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha"

DEPEND="virtual/glibc
	x11-base/xfree
	>=sys-apps/sed-4"
RDEPEND="virtual/glibc"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd ${S}
	find . -name '*.man' | xargs sed -i.bak -e 's/1M/8/g'
	epatch ${FILESDIR}/${PF}-gentoo.diff
}

src_compile() {
	xmkmf || die
	make Makefiles || die
	# make includes
	make canna || die
}

src_install() {
	make DESTDIR=${D} install || die
	make DESTDIR=${D} install.man || die
	dodir /usr/share/man/man8 /usr/share/man/ja/man8
	for i in cannaserver cannakill ; do
		mv ${D}/usr/share/man/man1/$i.1 \
			${D}/usr/share/man/man8/$i.8 || die
		mv ${D}/usr/share/man/ja/man1/$i.1 \
			${D}/usr/share/man/ja/man8/$i.8 || die
	done
	dodoc CHANGES.jp ChangeLog INSTALL* README* WHATIS*
	exeinto /etc/init.d ; newexe ${FILESDIR}/canna.initd canna || die
	insinto /etc/conf.d ; newins ${FILESDIR}/canna.confd canna || die
	insinto /etc/       ; newins ${FILESDIR}/canna.hosts hosts.canna || die
	keepdir /var/log/canna/ || die

	dosbin ${FILESDIR}/update-canna-dics_dir
	insinto /var/lib/canna/dic/dics.d/ ;\
		newins ${D}/var/lib/canna/dic/canna/dics.dir 00canna.dics.dir
}

pkg_postinst() {
	if [ -x /usr/sbin/update-canna-dics_dir ]; then
		einfo "Regenerating dics.dir file..."
		/usr/sbin/update-canna-dics_dir || die "Regenerating failed."
	fi
}

pkg_postrm() {
	if [ -x /usr/sbin/update-canna-dics_dir ]; then
		einfo "Regenerating dics.dir file..."
		/usr/sbin/update-canna-dics_dir || die "Regenerating failed."
	fi
}
