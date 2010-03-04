# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/erlang/erlang-13.2.4.ebuild,v 1.3 2010/03/04 09:31:30 fauli Exp $

EAPI=3
WX_GTK_VER="2.8"

inherit autotools elisp-common eutils multilib versionator wxwidgets

# NOTE: If you need symlinks for binaries please tell maintainers or
# open up a bug to let it be created.

# erlang uses a really weird versioning scheme which caused quite a few problems
# already. Thus we do a slight modification converting all letters to digits to
# make it more sane (see e.g. #26420)

# the next line selects the right source.
ERL_VER=($(get_version_components))
MY_PV="R$(get_major_version)B0${ERL_VER[2]}"

# ATTN!! Take care when processing the C, etc version!
MY_P=otp_src_${MY_PV}

DESCRIPTION="Erlang programming language, runtime environment, and large collection of libraries"
HOMEPAGE="http://www.erlang.org/"
SRC_URI="http://www.erlang.org/download/${MY_P}.tar.gz
	http://erlang.org/download/otp_doc_man_${MY_PV}.tar.gz
	doc? ( http://erlang.org/download/otp_doc_html_${MY_PV}.tar.gz )"

LICENSE="EPL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="doc emacs hipe java kpoll odbc smp sctp ssl tk wxwidgets"

RDEPEND=">=dev-lang/perl-5.6.1
	ssl? ( >=dev-libs/openssl-0.9.7d )
	emacs? ( virtual/emacs )
	java? ( >=virtual/jdk-1.2 )
	odbc? ( dev-db/unixODBC )"
DEPEND="${RDEPEND}
	wxwidgets? ( x11-libs/wxGTK:2.8[opengl] )
	sctp? ( net-misc/lksctp-tools )
	tk? ( dev-lang/tk )"

S="${WORKDIR}/${MY_P}"

SITEFILE=50${PN}-gentoo.el

pkg_setup() {
	use wxwidgets && wxwidgets_pkg_setup
}

src_prepare() {
	use odbc || sed -i 's: odbc : :' lib/Makefile

	if ! use wxwidgets; then
		sed -i 's: wx : :' lib/Makefile
		rm -rf lib/wx
	fi

	if use hipe; then
		ewarn
		ewarn "You enabled High performance Erlang. Be aware that this extension"
		ewarn "can break the compilation in many ways, especially on hardened systems."
		ewarn "Don't cry, don't file bugs, just disable it! If you have a fix, tell us though on Bugzilla."
		ewarn
	fi
	eautoreconf
}

src_configure() {
	use java || export JAVAC=false

	econf \
		--enable-threads \
		--enable-shared-zlib \ \
		$(use_enable sctp) \
		$(use_enable hipe) \
		$(use_with ssl ssl "${EPREFIX}"/usr) \
		$(use_enable ssl dynamic-ssl-lib) \
		$(use_enable kpoll kernel-poll) \
		$(use_enable smp smp-support) \
		|| die
}

src_compile() {
	use java || export JAVAC=false
	emake -j1 || die

	if use emacs ; then
		pushd lib/tools/emacs
		elisp-compile *.el || die
		popd
	fi
}

extract_version() {
	sed -n -e "/^$2 = \(.*\)$/s::\1:p" "${S}/$1/vsn.mk"
}

src_install() {
	local ERL_LIBDIR=/usr/$(get_libdir)/erlang
	local ERL_INTERFACE_VER=$(extract_version lib/erl_interface EI_VSN)
	local ERL_ERTS_VER=$(extract_version erts VSN)

	emake -j1 INSTALL_PREFIX="${D}" install || die
	dodoc AUTHORS README.md

	dosym "${ERL_LIBDIR}/bin/erl" /usr/bin/erl
	dosym "${ERL_LIBDIR}/bin/erlc" /usr/bin/erlc
	dosym "${ERL_LIBDIR}/bin/escript" /usr/bin/escript
	dosym \
		"${ERL_LIBDIR}/lib/erl_interface-${ERL_INTERFACE_VER}/bin/erl_call" \
		/usr/bin/erl_call
	dosym "${ERL_LIBDIR}/erts-${ERL_ERTS_VER}/bin/beam" /usr/bin/beam
	use smp && dosym "${ERL_LIBDIR}/erts-${ERL_ERTS_VER}/bin/beam.smp" /usr/bin/beam.smp

	## Remove ${D} from the following files
	sed "s:${D}::g" "${D}${ERL_LIBDIR}/bin/erl" || die
	sed "s:${D}::g" "${D}${ERL_LIBDIR}/bin/start" || die
	grep -rle "${D}" "${ED}/${ERL_LIBDIR}/erts-${ERL_ERTS_VER}" | xargs sed -i -e "s:${D}::g"

	## Clean up the no longer needed files
	rm "${ED}/${ERL_LIBDIR}/Install"||die

	for i in "${WORKDIR}"/man/man* ; do
		dodir "${ERL_LIBDIR}/${i##${WORKDIR}}"
	done
	for file in "${WORKDIR}"/man/man*/*.[1-9]; do
			# doman sucks so we can't use it
		cp ${file} "${ED}/${ERL_LIBDIR}"/man/man${file##*.}/
	done
	# extend MANPATH, so the normal man command can find it
	# see bug 189639
	dodir /etc/env.d/
	echo "MANPATH=\"${EPREFIX}${ERL_LIBDIR}/man\"" > "${ED}/etc/env.d/90erlang"

	if use doc ; then
		dohtml -A README,erl,hrl,c,h,kwc,info -r \
			"${WORKDIR}"/doc "${WORKDIR}"/lib "${WORKDIR}"/erts-*
	fi

	if use emacs ; then
		pushd "${S}"
		elisp-install erlang lib/tools/emacs/*.{el,elc}
		sed -e "s:/usr/share:${EPREFIX}/usr/share:g" \
			"${FILESDIR}"/${SITEFILE} > "${T}"/${SITEFILE}
		elisp-site-file-install "${T}"/${SITEFILE}
		popd
	fi

	# prepare erl for SMP, fixes bug #188112
	use smp && sed -i -e 's:\(exec.*erlexec\):\1 -smp:' \
		"${ED}/${ERL_LIBDIR}/bin/erl"
}

pkg_postinst() {
	use emacs && elisp-site-regen
	elog
	elog "If you need a symlink to one of Erlang's binaries,"
	elog "please open a bug on http://bugs.gentoo.org/"
	elog
	elog "Gentoo's versioning scheme differs from the author's, so please refer to this version as ${MY_PV}"
	elog
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
