# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/erlang/erlang-12.2.1.ebuild,v 1.9 2008/04/01 18:16:44 opfer Exp $

inherit elisp-common eutils flag-o-matic multilib versionator

# NOTE: You need to adjust the version number in the last comment.  If you need symlinks for
# binaries please tell maintainers or open up a bug to let it be created.

# erlang uses a really weird versioning scheme which caused quite a few problems
# already. Thus we do a slight modification converting all letters to digits to
# make it more sane (see e.g. #26420)

# the next line selects the right source.
MY_PV="R$(get_major_version)B-$(get_version_component_range 3)"

# ATTN!! Take care when processing the C, etc version!
MY_P=otp_src_${MY_PV}

DESCRIPTION="Erlang programming language, runtime environment, and large collection of libraries"
HOMEPAGE="http://www.erlang.org/"
SRC_URI="http://www.erlang.org/download/${MY_P}.tar.gz
	doc? ( http://erlang.org/download/otp_doc_man_${MY_PV}.tar.gz
		http://erlang.org/download/otp_doc_html_${MY_PV}.tar.gz )"

LICENSE="EPL"
SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="doc emacs hipe java kpoll odbc smp ssl tk"

RDEPEND=">=dev-lang/perl-5.6.1
	ssl? ( >=dev-libs/openssl-0.9.7d )
	emacs? ( virtual/emacs )
	java? ( >=virtual/jdk-1.2 )
	odbc? ( dev-db/unixODBC )"
DEPEND="${RDEPEND}
	tk? ( dev-lang/tk )"

S="${WORKDIR}/${MY_P}"

SITEFILE=50erlang-gentoo.el

pkg_setup() {
	if use ssl; then
		if is-ldflag --as-needed || is-flag --as-needed; then
			eerror "Don't use --as-needed in your LDFLAGS or CFLAGS for SSL support, this will fail."
			die
		fi
	fi
}

src_unpack() {

	unpack ${A}
	cd "${S}"

	use odbc || sed -i 's: odbc : :' lib/Makefile

	# make sure we only link ssl dynamically
	# will not be integrated by upstream for various reasons
	sed -i '/SSL_DYNAMIC_ONLY=/s:no:yes:' erts/configure #184419

	if use hipe; then
		ewarn
		ewarn "You enabled High performance Erlang. Be aware that this extension"
		ewarn "can break the compilation in many ways, especially on hardened systems."
		ewarn "Don't cry, don't file bugs, just disable it! If you have fix, tell us."
		ewarn
	fi
}

src_compile() {
	use java || export JAVAC=false

	econf \
		--enable-threads \
		$(use_enable hipe) \
		$(use_with ssl) \
		$(use_enable kpoll kernel-poll) \
		$(use_enable smp smp-support) \
		|| die "econf failed"
	emake -j1 || die "emake failed"

	if use emacs ; then
		pushd lib/tools/emacs
		elisp-compile *.el
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

	emake -j1 INSTALL_PREFIX="${D}" install || die "install failed"
	dodoc AUTHORS README

	dosym "${ERL_LIBDIR}/bin/erl" /usr/bin/erl
	dosym "${ERL_LIBDIR}/bin/erlc" /usr/bin/erlc
	dosym "${ERL_LIBDIR}/bin/ear" /usr/bin/ear
	dosym "${ERL_LIBDIR}/bin/escript" /usr/bin/escript
	dosym \
		"${ERL_LIBDIR}/lib/erl_interface-${ERL_INTERFACE_VER}/bin/erl_call" \
		/usr/bin/erl_call
	dosym "${ERL_LIBDIR}/erts-${ERL_ERTS_VER}/bin/beam" /usr/bin/beam

	## Remove ${D} from the following files
	dosed "${ERL_LIBDIR}/bin/erl"
	dosed "${ERL_LIBDIR}/bin/start"
	grep -rle "${D}" "${D}/${ERL_LIBDIR}/erts-${ERL_ERTS_VER}" | xargs sed -i -e "s:${D}::g"

	## Clean up the no longer needed files
	rm "${D}/${ERL_LIBDIR}/Install"

	if use doc ; then
		for i in "${WORKDIR}"/man/man* ; do
			dodir "${ERL_LIBDIR}/${i##${WORKDIR}}"
		done
		for file in "${WORKDIR}"/man/man*/*.[1-9]; do
			# Man page processing tools expect a capitalized "SEE ALSO" section
			# header, has been reported upstream, should be fixed in R12
			sed -i -e 's,\.SH See Also,\.SH SEE ALSO,g' ${file}
			# doman sucks so we can't use it
			cp ${file} "${D}/${ERL_LIBDIR}"/man/man${file##*.}/
		done
		# extend MANPATH, so the normal man command can find it
		# see bug 189639
		dodir /etc/env.d/
		echo "MANPATH=\"${ERL_LIBDIR}/man\"" > "${D}/etc/env.d/90erlang"
		dohtml -A README,erl,hrl,c,h,kwc,info -r \
			"${WORKDIR}"/doc "${WORKDIR}"/lib "${WORKDIR}"/erts-*
	fi

	if use emacs ; then
		pushd "${S}"
		elisp-install erlang lib/tools/emacs/*.{el,elc}
		elisp-site-file-install "${FILESDIR}"/${SITEFILE}
		popd
	fi

	# prepare erl for SMP, fixes bug #188112
	use smp && sed -i -e 's:\(exec.*erlexec\):\1 -smp:' \
		"${D}/${ERL_LIBDIR}/bin/erl"
}

pkg_postinst() {
	use emacs && elisp-site-regen
	elog
	elog "If you need a symlink to one of Erlang's binaries,"
	elog "please open a bug on http://bugs.gentoo.org/"
	elog
	elog "Gentoo's versioning scheme differs from the author's, so please refer to this version as R12B-1"
	elog
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
