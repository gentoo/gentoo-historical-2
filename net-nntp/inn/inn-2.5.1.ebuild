# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nntp/inn/inn-2.5.1.ebuild,v 1.7 2010/12/12 10:28:28 tomka Exp $

EAPI="2"

inherit autotools eutils fixheadtails multilib ssl-cert

DESCRIPTION="The Internet News daemon, fully featured NNTP server"
HOMEPAGE="https://www.isc.org/software/inn"
SRC_URI="ftp://ftp.isc.org/isc/inn/${P}.tar.gz"

SLOT="0"
LICENSE="as-is BSD GPL-2"
KEYWORDS="~amd64 ppc x86"
IUSE="berkdb innkeywords inntaggedhash ipv6 kerberos python sasl ssl"

RDEPEND="
	virtual/mta
	dev-perl/MIME-tools
	kerberos? ( virtual/krb5 )
	sasl? ( >=dev-libs/cyrus-sasl-2 )
	ssl? ( dev-libs/openssl )
	python? ( dev-lang/python )
	berkdb? ( sys-libs/db )
"
DEPEND="${RDEPEND}"

src_prepare() {
	#ht_fix_file configure.in support/fixscript.in
	sed -i -e "s/ -B .OLD//" Makefile.global.in || die "sed failed"

	# Do not treat LDFLAGS as if it contained libraries to link to
	sed -i m4/python.m4 -e 's|LDFLAGS||g' || die "sed python.m4 failed"

	# We do not have the biff service, but we do have comsat
	sed -i tests/lib/getnameinfo-t.c \
		-e 's|"biff"|"comsat"|g' \
		|| die "sed getnameinfo-t.c failed"

	eautoreconf
}

src_configure() {
	econf \
		--prefix=/usr/$(get_libdir)/news \
		--sysconfdir=/etc/news \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--with-control-dir=/usr/$(get_libdir)/news/bin/control \
		--with-filter-dir=/usr/$(get_libdir)/news/bin/filter \
		--with-db-dir=/var/spool/news/db \
		--with-doc-dir=/usr/share/doc/${PF} \
		--with-spool-dir=/var/spool/news \
		--with-log-dir=/var/log/news \
		--with-run-dir=/var/run/news \
		--with-tmp-dir=/var/spool/news/tmp \
		--disable-libtool \
		--with-gnu-ld \
		--enable-setgid-inews \
		--enable-uucp-rnews \
		$(use_with perl) \
		$(use_with python) \
		$(use_with kerberos kerberos /usr) \
		$(use_with sasl) \
		$(use_with ssl openssl) \
		$(use_with berkdb berkeleydb /usr) \
		$(use_enable ipv6) \
		$(use_enable !inntaggedhash largefiles) \
		$(use_enable inntaggedhash tagged-hash) \
		$(use_enable innkeywords keywords) \
		|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}/" P="" SPECIAL="" install || die "make install failed"

	chown -R root:0 "${D}"/usr/{$(get_libdir)/news/{lib,include},share/{doc,man}}
	chmod 644 "${D}"/etc/news/*
	for file in control.ctl expire.ctl incoming.conf nntpsend.ctl passwd.nntp readers.conf
	do
		chmod 640 "${D}"/etc/news/${file}
	done

	# Prevent old db/* files from being overwritten
	insinto /usr/share/inn/dbexamples
	newins site/active.minimal active
	newins site/newsgroups.minimal newsgroups

	keepdir \
		/var/{log,run}/news \
		/var/spool/news/{,archive,articles,db,incoming{,/bad},innfeed,outgoing,overview,tmp}

	dodoc ChangeLog MANIFEST README* doc/checklist
	use ipv6 && dodoc doc/IPv6-info

	# So other programs can build against INN. (eg. Suck)
	insinto /usr/$(get_libdir)/news/include
	doins include/*.h

	doinitd "${FILESDIR}"/innd
}

pkg_postinst() {
	for db_file in active newsgroups
	do
		[[ -f ${ROOT}/var/spool/news/db/${db_file} ]] && continue

		if [[ -f ${ROOT}/usr/share/inn/dbexamples/${db_file} ]]
		then
			cp "${ROOT}"/usr/share/inn/dbexamples/${db_file} "${ROOT}"/var/spool/news/db/${db_file}
		else
			touch "${ROOT}"/var/spool/news/db/${db_file}
		fi

		chown news:news "${ROOT}"/var/spool/news/db/${db_file}
		chmod 664 "${ROOT}"/var/spool/news/db/${db_file}
	done

	elog "Do not forget to update your cron entries, and also run"
	elog "makedbz if you need to.  If this is a first-time installation"
	elog "a minimal active file has been installed.  You will need to"
	elog "touch history and run 'makedbz -i' to initialize the history"
	elog "database.  See INSTALL for more information."
	elog
	elog "You need to assign a real shell to the news user, or else"
	elog "starting inn will fail. You can use 'usermod -s /bin/bash news'"
	elog "for this."

	if use ssl
	then
		install_cert /etc/news/cert/cert
		chown news:news "${ROOT}"/etc/news/cert/cert.{crt,csr,key,pem}

		elog
		elog "You may want to start nnrpd manually for native ssl support."
		elog "If you choose to do so, automating this with a bootscript might"
		elog "also be a good choice."
		elog "Have a look at man nnrpd for valid parameters."
		elog
		elog "The certificate location in /etc/news/sasl.conf has been changed"
		elog "to /etc/news/cert!"

	fi
}

pkg_postrm() {
	elog
	elog "If you want your newsspool or altered configuration files"
	elog "to be removed, please do so now manually."
	elog
}

pkg_config() {
	NEWSSPOOL_DIR="${ROOT}/var/spool/news"
	NEWS_SHELL="`awk -F':' '/^news:/ {print $7;}' ${ROOT}/etc/passwd`"
	NEWS_ERRFLAG="0"

	if [[ ${NEWS_SHELL} == /bin/false || ${NEWS_SHELL} == /dev/null ]]
	then
		if [ ${UID} -eq 0 ]
		then
			einfo "Changing shell to /bin/bash for user news..."
			usermod -s /bin/bash news
		else
			NEWS_ERRFLAG=1
			eerror
			eerror "Could not change shell for user news."
			eerror "Please run 'usermod -s /bin/bash news' as root."
		fi
	else
		einfo "Shell for user news unchanged ('${NEWS_SHELL}')."
		if [[ ${NEWS_SHELL} != /bin/sh && ${NEWS_SHELL} != /bin/bash ]]
		then
			ewarn "You might want to change it to '/bin/bash', though."
		fi
	fi

	if [[ ! -e ${NEWSSPOOL_DIR}/db/history ]]
	then
		if [[ ! -f ${NEWSSPOOL_DIR}/db/history.dir \
			&& ! -f ${NEWSSPOOL_DIR}/db/history.pag \
			&& ! -f ${NEWSSPOOL_DIR}/db/history.hash \
			&& ! -f ${NEWSSPOOL_DIR}/db/history.index ]]
		then
			einfo "Building history database..."

			touch "${NEWSSPOOL_DIR}"/db/history
			chown news:news "${NEWSSPOOL_DIR}"/db/history
			chmod 644 "${NEWSSPOOL_DIR}"/db/history

			su - news -c "/usr/$(get_libdir)/news/bin/makedbz -i"
			[[ -f ${NEWSSPOOL_DIR}/db/history.n.dir ]] && mv -f "${NEWSSPOOL_DIR}"/db/history.n.dir "${NEWSSPOOL_DIR}"/db/history.dir
			[[ -f ${NEWSSPOOL_DIR}/db/history.n.pag ]] && mv -f "${NEWSSPOOL_DIR}"/db/history.n.pag "${NEWSSPOOL_DIR}"/db/history.pag
			[[ -f ${NEWSSPOOL_DIR}/db/history.n.hash ]] && mv -f "${NEWSSPOOL_DIR}"/db/history.n.hash "${NEWSSPOOL_DIR}"/db/history.hash
			[[ -f ${NEWSSPOOL_DIR}/db/history.n.index ]] && mv -f "${NEWSSPOOL_DIR}"/db/history.n.index "${NEWSSPOOL_DIR}"/db/history.index
			su - news -c /usr/$(get_libdir)/news/bin/makehistory
		else
			NEWS_ERRFLAG="1"
			eerror
			eerror "Your installation seems to be screwed up."
			eerror "${NEWSSPOOL_DIR}/db/history does not exist, but there's"
			eerror "one of the files history.dir, history.hash or history.index"
			eerror "within ${NEWSSPOOL_DIR}/db."
			eerror "Use your backup to restore the history database."
		fi
	else
		einfo "${NEWSSPOOL_DIR}/db/history found. Leaving history database as it is."
	fi

	INNCFG_INODES="$(sed -e '/innwatchspoolnodes/ ! d' /etc/news/inn.conf | sed -e 's/[^ ]*[ ]*\([^ ]*\)/\1/')"
	INNSPOOL_INODES="$(df -Pi ${NEWSSPOOL_DIR} | sed -e 's/[^ ]*[ ]*\([^ ]*\).*/\1/' | sed -e '1 d')"
	if [[ ${INNCFG_INODES} -gt ${INNSPOOL_INODES} ]]
	then
		ewarn "Setting innwatchspoolinodes to zero, because the filesystem behind"
		ewarn "$NEWSSPOOL_DIR works without inodes."
		ewarn
		cp /etc/news/inn.conf /etc/news/inn.conf.OLD
		einfo "A copy of your old inn.conf has been saved to /etc/news/inn.conf.OLD."
		sed -i -e '/innwatchspoolnodes/ s/\([^ ]*\)\([ ]*\).*/\1\20/' /etc/news/inn.conf
		chown news:news /etc/news/inn.conf
		chmod 644 /etc/news/inn.conf
	fi

	INNCHECK_LINES="$(su - news -c "/usr/$(get_libdir)/news/bin/inncheck | wc -l")"
	if [[ ${INNCHECK_LINES} -gt 0 ]]
	then
		NEWS_ERRFLAG="1"
		ewarn "inncheck most certainly found an error."
		ewarn "Please check its output:"
		eerror "`su - news -c /usr/$(get_libdir)/news/bin/inncheck`"
	fi

	if [[ ${NEWS_ERRFLAG} -gt 0 ]]
	then
		eerror
		eerror "There were one or more errors/warnings checking your configuration."
		eerror "Please read inn's documentation and fix them accordingly."
	else
		einfo
		einfo "Inn configuration tests passed successfully."
		einfo
		ewarn "Please ensure you configured inn properly."
	fi
}
