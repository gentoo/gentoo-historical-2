# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/git/git-1.5.3.5.ebuild,v 1.2 2007/12/17 05:23:41 robbat2 Exp $

inherit toolchain-funcs eutils elisp-common perl-module bash-completion

MY_PV="${PV/_rc/.rc}"
MY_P="${PN}-${MY_PV}"

DOC_VER=${MY_PV}

DESCRIPTION="GIT - the stupid content tracker, the revision control system heavily used by the Linux kernel team"
HOMEPAGE="http://git.or.cz/"
SRC_URI="mirror://kernel/software/scm/git/${MY_P}.tar.bz2
		mirror://kernel/software/scm/git/${PN}-manpages-${DOC_VER}.tar.bz2
		doc? ( mirror://kernel/software/scm/git/${PN}-htmldocs-${DOC_VER}.tar.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="curl doc emacs gtk iconv mozsha1 perl ppcsha1 tk webdav"

DEPEND="
	!app-misc/git
	dev-libs/openssl
	sys-libs/zlib
	dev-lang/perl
	tk?     ( dev-lang/tk )
	curl?   ( net-misc/curl )
	webdav? ( dev-libs/expat )
	emacs?  ( virtual/emacs )"
RDEPEND="${DEPEND}
	perl?   ( dev-perl/Error )
	gtk?    ( >=dev-python/pygtk-2.8 )"

SITEFILE=72${PN}-gentoo.el
S="${WORKDIR}/${MY_P}"

# This is needed because for some obscure reasons future calls to make don't
# pick up these exports if we export them in src_unpack()
exportmakeopts() {
	local myopts

	if use mozsha1 ; then
		myopts="${myopts} MOZILLA_SHA1=YesPlease"
	elif use ppcsha1 ; then
		myopts="${myopts} PPC_SHA1=YesPlease"
	fi

	if use curl ; then
		use webdav || myopts="${myopts} NO_EXPAT=YesPlease"
	else
		myopts="${myopts} NO_CURL=YesPlease"
		use webdav && ewarn "USE=webdav only matters with USE=curl. Ignoring."
	fi

	myopts="${myopts} WITH_SEND_EMAIL=YesPlease"

	use iconv || myopts="${myopts} NO_ICONV=YesPlease"

	export MY_MAKEOPTS=${myopts}
}

showpkgdeps() {
	local pkg=$1
	shift
	elog "  $(printf "%-17s:" ${pkg}) ${@}"
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${PN}-1.5.3-symlinks.patch

	sed -i \
		-e "s:^\(CFLAGS = \).*$:\1${CFLAGS} -Wall:" \
		-e "s:^\(LDFLAGS = \).*$:\1${LDFLAGS}:" \
		-e "s:^\(CC = \).*$:\1$(tc-getCC):" \
		-e "s:^\(AR = \).*$:\1$(tc-getAR):" \
		-e 's:ln :ln -s :g' \
		Makefile || die "sed failed"

	exportmakeopts
}

src_compile() {
	emake ${MY_MAKEOPTS} DESTDIR="${D}" prefix=/usr || die "make failed"

	if use emacs ; then
		elisp-compile contrib/emacs/{,vc-}git.el || die "emacs modules failed"
	fi
}

src_install() {
	emake ${MY_MAKEOPTS} DESTDIR="${D}" prefix=/usr install || \
		die "make install failed"

	use tk || rm "${D}"/usr/bin/git{k,-gui}

	doman "${WORKDIR}"/man?/*

	dodoc README Documentation/SubmittingPatches
	if use doc ; then
		dodoc Documentation/technical/*
		dodir /usr/share/doc/${PF}/html
		cp -r "${WORKDIR}"/{*.html,howto} "${D}"/usr/share/doc/${PF}/html
	fi

	dobashcompletion contrib/completion/git-completion.bash ${PN}

	if use emacs ; then
		elisp-install ${PN} contrib/emacs/{,vc-}git.el* || \
			die "elisp-install failed"
		elisp-site-file-install "${FILESDIR}"/${SITEFILE}
		# don't add automatically to the load-path, so the sitefile
		# can do a conditional loading
		touch "${D}"/"${SITELISP}"/${PN}/.nosearch
	fi

	if use gtk ; then
		dobin "${S}"/contrib/gitview/gitview
		use doc && dodoc "${S}"/contrib/gitview/gitview.txt
	fi

	dodir /usr/share/${PN}/contrib
	cp -rf \
		"${S}"/contrib/{vim,stats,workdir,hg-to-git,fast-import,hooks} \
		"${D}"/usr/share/${PN}/contrib

	insinto /etc/xinetd.d
	newins "${FILESDIR}"/git-daemon.xinetd git-daemon

	newinitd "${FILESDIR}"/git-daemon.initd git-daemon
	newconfd "${FILESDIR}"/git-daemon.confd git-daemon

	fixlocalpod
}

src_test() {
	has_version dev-util/subversion || \
		MY_MAKEOPTS="${MY_MAKEOPTS} NO_SVN_TESTS=YesPlease"
	has_version app-arch/unzip || \
		rm "${S}"/t/t5000-tar-tree.sh
	# Stupid CVS won't let some people commit as root
	rm "${S}"/t/t9200-git-cvsexportcommit.sh
	emake ${MY_MAKEOPTS} DESTDIR="${D}" prefix=/usr test || die "tests failed"
}

pkg_postinst() {
	if use emacs ; then
		elisp-site-regen
		elog "GNU Emacs has built-in Git support in versions greater 22.1."
		elog "You can disable the emacs USE flag for dev-util/git"
		elog "if you are using such a version."
	fi
	elog "These additional scripts need some dependencies:"
	echo
	showpkgdeps git-archimport "dev-util/tla"
	showpkgdeps git-cvsimport ">=dev-util/cvsps-2.1"
	showpkgdeps git-svnimport "dev-util/subversion(USE=perl)"
	showpkgdeps git-svn \
		"dev-util/subversion(USE=perl)" \
		"dev-perl/libwww-perl" \
		"dev-perl/TermReadKey"
	showpkgdeps git-quiltimport "dev-util/quilt"
	showpkgdeps git-cvsserver "dev-perl/DBI" "dev-perl/DBD-SQLite"
	showpkgdeps git-instaweb \
		"|| ( www-servers/lighttpd www-servers/apache(SLOT=2) )"
	showpkgdeps git-send-email "USE=perl"
	showpkgdeps git-remote "USE=perl"
	echo
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
