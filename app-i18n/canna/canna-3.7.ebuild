# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/canna/canna-3.7.ebuild,v 1.4 2004/03/30 06:14:16 spyderous Exp $

inherit cannadic

IUSE="doc"

MY_P="Canna${PV//./}"

DESCRIPTION="A client-server based Kana-Kanji conversion system"
HOMEPAGE="http://canna.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/canna/7240/${MY_P}.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc -alpha amd64"

DEPEND="virtual/glibc
	virtual/x11
	>=sys-apps/sed-4
	doc? ( app-text/ptex )"
RDEPEND="virtual/glibc"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd ${S}
	find . -name '*.man' -o -name '*.jmn' | xargs sed -i.bak -e 's/1M/8/g'
	sed -e "s%@cannapkgver@%${PF}%" \
		${FILESDIR}/${P}-gentoo.diff.in > ${T}/${P}-gentoo.diff
	epatch ${T}/${P}-gentoo.diff
	cd dic/phono
	epatch ${FILESDIR}/${PN}-kpdef-gentoo.diff
}

src_compile() {

	xmkmf || die
	#make libCannaDir=../lib/canna canna || die
	make canna || die

	if [ -n "`use doc`" ] ; then
		einfo "Compiling DVI, PS (and PDF) document"
		cd doc/man/guide/tex
		xmkmf || die
		make JLATEXCMD=platex \
			DVI2PSCMD="dvips -f" \
			canna.dvi canna.ps || die
		if has_version 'app-text/dvipdfmx' && \
			( has_version 'app-text/acroread' \
			|| has_version 'app-text/xpdf-japanese' ); then
			make JLATEXCMD=platex \
				DVI2PSCMD="dvips -f" \
				canna.pdf || die
		fi
	fi
}

src_install() {
	make DESTDIR=${D} install || die
	make DESTDIR=${D} install.man || die

	# install default.canna (removed from Canna36p4)
	insinto /usr/share/canna
	newins misc/initfiles/verbose.canna default.canna

	# cannakill should link to /usr/bin/catdic
	dosym ../bin/catdic /usr/sbin/cannakill

	dodir /usr/share/man/man8 /usr/share/man/ja/man8
	for man in cannaserver cannakill ; do
		for mandir in ${D}/usr/share/man ${D}/usr/share/man/ja ; do
			mv ${mandir}/man1/${man}.1 ${mandir}/man8/${man}.8
		done
	done

	dodoc CHANGES.jp ChangeLog INSTALL* README* WHATIS*

	if [ -n "`use doc`" ] ; then
		insinto /usr/share/doc/${PF}
		doins doc/man/guide/tex/canna.{dvi,ps,pdf}
	fi

	exeinto /etc/init.d ; newexe ${FILESDIR}/canna.initd.new canna || die
	insinto /etc/conf.d ; newins ${FILESDIR}/canna.confd canna || die
	insinto /etc/       ; newins ${FILESDIR}/canna.hosts hosts.canna || die
	keepdir /var/log/canna/ || die

	# for backward compatibility
	dosbin ${FILESDIR}/update-canna-dics_dir

	insinto /var/lib/canna/dic/dics.d/
	newins ${D}/var/lib/canna/dic/canna/dics.dir 00canna.dics.dir

	# fix permission for user dictionary
	keepdir /var/lib/canna/dic/{user,group}
	fowners root:bin /var/lib/canna/dic/{user,group}
	fperms 775 /var/lib/canna/dic/{user,group}
}

pkg_postinst() {

	update-cannadic-dir
	einfo
	einfo "Canna dictionary format has been changed."
	einfo "You should rebuild app-dict/canna-* after emerge."
	einfo
}

pkg_prerm () {

	if [ -S /tmp/.iroha_unix/IROHA ] ; then
		# make sure cannaserver get stopped because otherwise
		# we cannot stop it with /etc/init.d after emerge -C canna
		einfo
		einfo "Stopping Canna for safe unmerge"
		einfo
		/etc/init.d/canna stop
		touch ${T}/canna.cookie
	fi
}

pkg_postrm () {

	if [ -f /usr/sbin/cannaserver -a -e ${T}/canna.cookie ] ; then
		#update-cannadic-dir
		einfo
		einfo "Restarting Canna"
		einfo
		/etc/init.d/canna start
		rm -f ${T}/canna.cookie
	fi
}
