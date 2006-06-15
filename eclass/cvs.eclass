# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/cvs.eclass,v 1.64 2006/06/15 14:45:59 vapier Exp $
#
# Maintainer: vapier@gentoo.org (and anyone who wants to help)

inherit eutils

# This eclass provides the generic cvs fetching functions.  To use
# this from an ebuild, set the `ebuild-configurable settings' as
# specified below in your ebuild before inheriting.  Then either leave
# the default src_unpack or extend over cvs_src_unpack.  If you find
# that you need to call the cvs_* functions directly, I'd be
# interested to hear about it.

# TODO:

# Implement more auth types (gserver?, kserver?)

# Support additional remote shells with `ext' authentication (does
# anyone actually need to use it with anything other than SSH?)



# Users shouldn't change these settings!  The ebuild/eclass inheriting
# this eclass will take care of that.  If you want to set the global
# KDE cvs ebuilds' settings, see the comments in kde-source.eclass.

# --- begin ebuild-configurable settings

# ECVS_CVS_COMMAND -- CVS command to run
#
# You can set, for example, "cvs -t" for extensive debug information
# on the cvs connection.  The default of "cvs -q -f -z4" means to be
# quiet, to disregard the ~/.cvsrc config file and to use maximum
# compression.

[ -z "$ECVS_CVS_COMMAND" ] && ECVS_CVS_COMMAND="cvs -q -f -z4"


# ECVS_UP_OPTS, ECVS_CO_OPTS -- CVS options given after the cvs
# command (update or checkout).
#
# Don't remove -dP from update or things won't work.

[ -z "$ECVS_UP_OPTS" ] && ECVS_UP_OPTS="-dP"
[ -z "$ECVS_CO_OPTS" ] && ECVS_CO_OPTS=""


# ECVS_LOCAL -- If this is set, the CVS module will be fetched
# non-recursively.  Refer to the information in the CVS man page
# regarding the -l command option (not the -l global option).


# ECVS_LOCALNAME -- local name of checkout directory
#
# This is useful if the module on the server is called something
# common like 'driver' or is nested deep in a tree, and you don't like
# useless empty directories.
#
# WARNING: Set this only from within ebuilds!  If set in your shell or
# some such, things will break because the ebuild won't expect it and
# have e.g. a wrong $S setting.


# ECVS_TOP_DIR -- The directory under which CVS modules are checked
# out.

[ -z "$ECVS_TOP_DIR" ] && ECVS_TOP_DIR="${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/cvs-src"

# ECVS_SERVER -- CVS path
#
# The format is "server:/dir", e.g. "anoncvs.kde.org:/home/kde".
# Remove the other parts of the full CVSROOT, which might look like
# ":pserver:anonymous@anoncvs.kde.org:/home/kde"; this is generated
# using other settings also.
#
# Set this to "offline" to disable fetching (i.e. to assume the module
# is already checked out in ECVS_TOP_DIR).

[ -z "$ECVS_SERVER" ] && ECVS_SERVER="offline"


# ECVS_MODULE -- the name of the CVS module to be fetched
#
# This must be set when cvs_src_unpack is called.  This can include
# several directory levels, i.e. "foo/bar/baz"

#[ -z "$ECVS_MODULE" ] && die "$ECLASS: error: ECVS_MODULE not set, cannot continue"


# ECVS_BRANCH -- the name of the branch/tag to use

# The default is "HEAD".  The following default _will_ reset your
# branch checkout to head if used.

#[ -z "$ECVS_BRANCH" ] && ECVS_BRANCH="HEAD"


# ECVS_AUTH -- authentication method to use
#
# Possible values are "pserver" and "ext".  If `ext' authentication is
# used, the remote shell to use can be specified in CVS_RSH (SSH is
# used by default).  Currently, the only supported remote shell for
# `ext' authentication is SSH.
#
# Armando Di Cianno <fafhrd@gentoo.org> 2004/09/27
# - Added "no" as a server type, which uses no AUTH method, nor
#    does it login
#  e.g.
#   "cvs -danoncvs@savannah.gnu.org:/cvsroot/backbone co System"
#   ( from gnustep-apps/textedit )
[ -z "$ECVS_AUTH" ] && ECVS_AUTH="pserver"

# ECVS_USER -- Username to use for authentication on the remote server
[ -z "$ECVS_USER" ] && ECVS_USER="anonymous"


# ECVS_PASS -- Password to use for authentication on the remote server
[ -z "$ECVS_PASS" ] && ECVS_PASS=""


# ECVS_SSH_HOST_KEY
#
# If SSH is used for `ext' authentication, use this variable to
# specify the host key of the remote server.  The format of the value
# should be the same format that is used for the SSH known hosts file.
#
# WARNING: If a SSH host key is not specified using this variable, the
# remote host key will not be verified.


# ECVS_CLEAN -- Set this to get a clean copy when updating (passes the
# -C option to cvs update)


# ECVS_RUNAS
#
# Specifies an alternate (non-root) user to use to run cvs.  Currently
# b0rked and wouldn't work with portage userpriv anyway without
# special magic.

# [ -z "$ECVS_RUNAS" ] && ECVS_RUNAS="`whoami`"


# ECVS_SUBDIR -- deprecated, do not use
[ -n "$ECVS_SUBDIR" ] && die "ERROR: deprecated ECVS_SUBDIR defined. Please fix this ebuild."


# --- end ebuild-configurable settings ---

# add cvs to deps
# ssh is used for ext auth
# sudo is used to run as a specified user
DEPEND="dev-util/cvs"

[ -n "$ECVS_RUNAS" ] && DEPEND="$DEPEND app-admin/sudo"

if [ "$ECVS_AUTH" == "ext" ]; then
	#default to ssh
	[ -z "$CVS_RSH" ] && export CVS_RSH="ssh"
	if [ "$CVS_RSH" != "ssh" ]; then
		die "Support for ext auth with clients other than ssh has not been implemented yet"
	fi
	DEPEND="${DEPEND} net-misc/openssh"
fi

# called from cvs_src_unpack
cvs_fetch() {

	# Make these options local variables so that the global values are
	# not affected by modifications in this function.

	local ECVS_COMMAND="${ECVS_COMMAND}"
	local ECVS_UP_OPTS="${ECVS_UP_OPTS}"
	local ECVS_CO_OPTS="${ECVS_CO_OPTS}"

	# Fix for sourceforge which doesnt want -z>3 anymore.

	(echo $ECVS_SERVER | grep -q sourceforge) \
		&& [ "$ECVS_CVS_COMMAND" == "cvs -q -f -z4" ] \
		&& ECVS_CVS_COMMAND="cvs -q -f -z3"

	debug-print-function $FUNCNAME $*

	# Update variables that are modified by ebuild parameters, which
	# should be effective every time cvs_fetch is called, and not just
	# every time cvs.eclass is inherited

	# Handle parameter for local (non-recursive) fetching

	if [ -n "$ECVS_LOCAL" ]; then
		ECVS_UP_OPTS="$ECVS_UP_OPTS -l"
		ECVS_CO_OPTS="$ECVS_CO_OPTS -l"
	fi

	# Handle ECVS_BRANCH option
	#
	# Because CVS auto-switches branches, we just have to pass the
	# correct -rBRANCH option when updating.

	if [ -n "$ECVS_BRANCH" ]; then
		ECVS_UP_OPTS="$ECVS_UP_OPTS -r$ECVS_BRANCH"
		ECVS_CO_OPTS="$ECVS_CO_OPTS -r$ECVS_BRANCH"
	fi

	# Handle ECVS_LOCALNAME, which specifies the local directory name
	# to use.  Note that the -d command option is not equivalent to
	# the global -d option.

	if [ "$ECVS_LOCALNAME" != "$ECVS_MODULE" ]; then
		ECVS_CO_OPTS="$ECVS_CO_OPTS -d $ECVS_LOCALNAME"
	fi


	if [ -n "$ECVS_CLEAN" ]; then
		ECVS_UP_OPTS="$ECVS_UP_OPTS -C"
	fi


	# It would be easiest to always be in "run-as mode", logic-wise,
	# if sudo didn't ask for a password even when sudo'ing to `whoami`.

	if [ -z "$ECVS_RUNAS" ]; then
		run=""
	else
		run="sudo -u $ECVS_RUNAS"
	fi

	# Create the top dir if needed

	if [ ! -d "$ECVS_TOP_DIR" ]; then

		# Note that the addwrite statements in this block are only
		# there to allow creating ECVS_TOP_DIR; we allow writing
		# inside it separately.

		# This is because it's simpler than trying to find out the
		# parent path of the directory, which would need to be the
		# real path and not a symlink for things to work (so we can't
		# just remove the last path element in the string)

		debug-print "$FUNCNAME: checkout mode. creating cvs directory"
		addwrite /foobar
		addwrite /
		$run mkdir -p "/$ECVS_TOP_DIR"
		export SANDBOX_WRITE="${SANDBOX_WRITE//:\/foobar:\/}"
	fi

	# In case ECVS_TOP_DIR is a symlink to a dir, get the real path,
	# otherwise addwrite() doesn't work.

	cd -P "$ECVS_TOP_DIR" > /dev/null
	ECVS_TOP_DIR="`/bin/pwd`"

	# Disable the sandbox for this dir
	addwrite "$ECVS_TOP_DIR"

	# Chown the directory and all of its contents
	if [ -n "$ECVS_RUNAS" ]; then
		$run chown -R "$ECVS_RUNAS" "/$ECVS_TOP_DIR"
	fi

	# Determine the CVS command mode (checkout or update)
	if [ ! -d "$ECVS_TOP_DIR/$ECVS_LOCALNAME/CVS" ]; then
		mode=checkout
	else
		mode=update
	fi


	# Our server string (i.e. CVSROOT) without the password so it can
	# be put in Root
	if [ "$ECVS_AUTH" == "no" ]
	then
		local server="${ECVS_USER}@${ECVS_SERVER}"
	else
		local server=":${ECVS_AUTH}:${ECVS_USER}@${ECVS_SERVER}"
	fi

	# Switch servers automagically if needed
	if [ "$mode" == "update" ]; then
		cd /$ECVS_TOP_DIR/$ECVS_LOCALNAME
		local oldserver="`$run cat CVS/Root`"
		if [ "$server" != "$oldserver" ]; then

			einfo "Changing the CVS server from $oldserver to $server:"
			debug-print "$FUNCNAME: Changing the CVS server from $oldserver to $server:"

			einfo "Searching for CVS directories ..."
			local cvsdirs="`$run find . -iname CVS -print`"
			debug-print "$FUNCNAME: CVS directories found:"
			debug-print "$cvsdirs"

			einfo "Modifying CVS directories ..."
			for x in $cvsdirs; do
				debug-print "In $x"
				$run echo "$server" > "$x/Root"
			done

		fi
	fi

	# Prepare a cvspass file just for this session, we don't want to
	# mess with ~/.cvspass
	touch "${T}/cvspass"
	export CVS_PASSFILE="${T}/cvspass"
	if [ -n "$ECVS_RUNAS" ]; then
		chown "$ECVS_RUNAS" "${T}/cvspass"
	fi

	# The server string with the password in it, for login
	cvsroot_pass=":${ECVS_AUTH}:${ECVS_USER}:${ECVS_PASS}@${ECVS_SERVER}"

	# Ditto without the password, for checkout/update after login, so
	# that the CVS/Root files don't contain the password in plaintext
	if [ "$ECVS_AUTH" == "no" ]
	then
		cvsroot_nopass="${ECVS_USER}@${ECVS_SERVER}"
	else
		cvsroot_nopass=":${ECVS_AUTH}:${ECVS_USER}@${ECVS_SERVER}"
	fi

	# Commands to run
	cmdlogin="${run} ${ECVS_CVS_COMMAND} -d \"${cvsroot_pass}\" login"
	cmdupdate="${run} ${ECVS_CVS_COMMAND} -d \"${cvsroot_nopass}\" update ${ECVS_UP_OPTS} ${ECVS_LOCALNAME}"
	cmdcheckout="${run} ${ECVS_CVS_COMMAND} -d \"${cvsroot_nopass}\" checkout ${ECVS_CO_OPTS} ${ECVS_MODULE}"

	# Execute commands

	cd "${ECVS_TOP_DIR}"
	if [ "${ECVS_AUTH}" == "pserver" ]; then
		einfo "Running $cmdlogin"
		eval $cmdlogin || die "cvs login command failed"
		if [ "${mode}" == "update" ]; then
			einfo "Running $cmdupdate"
			eval $cmdupdate || die "cvs update command failed"
		elif [ "${mode}" == "checkout" ]; then
			einfo "Running $cmdcheckout"
			eval $cmdcheckout|| die "cvs checkout command failed"
		fi
	elif [ "${ECVS_AUTH}" == "ext" ] || [ "${ECVS_AUTH}" == "no" ]; then

		# Hack to support SSH password authentication

		# Backup environment variable values
		local CVS_ECLASS_ORIG_CVS_RSH="${CVS_RSH}"

		if [ "${SSH_ASKPASS+set}" == "set" ]; then
			local CVS_ECLASS_ORIG_SSH_ASKPASS="${SSH_ASKPASS}"
		else
			unset CVS_ECLASS_ORIG_SSH_ASKPASS
		fi

		if [ "${DISPLAY+set}" == "set" ]; then
			local CVS_ECLASS_ORIG_DISPLAY="${DISPLAY}"
		else
			unset CVS_ECLASS_ORIG_DISPLAY
		fi

		if [ "${CVS_RSH}" == "ssh" ]; then

			# Force SSH to use SSH_ASKPASS by creating python wrapper

			export CVS_RSH="${T}/cvs_sshwrapper"
			cat > "${CVS_RSH}"<<EOF
#!/usr/bin/python
import fcntl
import os
import sys
try:
	fd = os.open('/dev/tty', 2)
	TIOCNOTTY=0x5422
	try:
		fcntl.ioctl(fd, TIOCNOTTY)
	except:
		pass
	os.close(fd)
except:
	pass
newarglist = sys.argv[:]
EOF

			# disable X11 forwarding which causes .xauth access violations
			# - 20041205 Armando Di Cianno <fafhrd@gentoo.org>
			echo "newarglist.insert(1, '-oClearAllForwardings=yes')" \
				>> "${CVS_RSH}"
			echo "newarglist.insert(1, '-oForwardX11=no')" \
				>> "${CVS_RSH}"

			# Handle SSH host key checking

			local CVS_ECLASS_KNOWN_HOSTS="${T}/cvs_ssh_known_hosts"
			echo "newarglist.insert(1, '-oUserKnownHostsFile=${CVS_ECLASS_KNOWN_HOSTS}')" \
				>> "${CVS_RSH}"

			if [ -z "${ECVS_SSH_HOST_KEY}" ]; then
				ewarn "Warning: The SSH host key of the remote server will not be verified."
				einfo "A temporary known hosts list will be used."
				local CVS_ECLASS_STRICT_HOST_CHECKING="no"
				touch "${CVS_ECLASS_KNOWN_HOSTS}"
			else
				local CVS_ECLASS_STRICT_HOST_CHECKING="yes"
				echo "${ECVS_SSH_HOST_KEY}" > "${CVS_ECLASS_KNOWN_HOSTS}"
			fi

			echo -n "newarglist.insert(1, '-oStrictHostKeyChecking=" \
				>> "${CVS_RSH}"
			echo "${CVS_ECLASS_STRICT_HOST_CHECKING}')" \
				>> "${CVS_RSH}"
			echo "os.execv('/usr/bin/ssh', newarglist)" \
				>> "${CVS_RSH}"

			chmod a+x "${CVS_RSH}"

			# Make sure DISPLAY is set (SSH will not use SSH_ASKPASS
			# if DISPLAY is not set)

			[ -z "${DISPLAY}" ] && DISPLAY="DISPLAY"
			export DISPLAY

			# Create a dummy executable to echo $ECVS_PASS

			export SSH_ASKPASS="${T}/cvs_sshechopass"
			if [ "${ECVS_AUTH}" != "no" ]; then
				echo -en "#!/bin/bash\necho \"$ECVS_PASS\"\n" \
					> "${SSH_ASKPASS}"
			else
				echo -en "#!/bin/bash\nreturn\n" \
					> "${SSH_ASKPASS}"

			fi
			chmod a+x "${SSH_ASKPASS}"
		fi

		if [ "${mode}" == "update" ]; then
			einfo "Running $cmdupdate"
			eval $cmdupdate || die "cvs update command failed"
		elif [ "${mode}" == "checkout" ]; then
			einfo "Running $cmdcheckout"
			eval $cmdcheckout|| die "cvs checkout command failed"
		fi

		# Restore environment variable values
		export CVS_RSH="${CVS_ECLASS_ORIG_CVS_RSH}"
		if [ "${CVS_ECLASS_ORIG_SSH_ASKPASS+set}" == "set" ]; then
			export SSH_ASKPASS="${CVS_ECLASS_ORIG_SSH_ASKPASS}"
		else
			unset SSH_ASKPASS
		fi

		if [ "${CVS_ECLASS_ORIG_DISPLAY+set}" == "set" ]; then
			export DISPLAY="${CVS_ECLASS_ORIG_DISPLAY}"
		else
			unset DISPLAY
		fi
	fi

	# Restore ownership.  Not sure why this is needed, but someone
	# added it in the orig ECVS_RUNAS stuff.
	if [ -n "$ECVS_RUNAS" ]; then
		chown `whoami` "${T}/cvspass"
	fi

}


cvs_src_unpack() {

	debug-print-function $FUNCNAME $*

	debug-print "$FUNCNAME: init:
	ECVS_CVS_COMMAND=$ECVS_CVS_COMMAND
	ECVS_UP_OPTS=$ECVS_UP_OPTS
	ECVS_CO_OPTS=$ECVS_CO_OPTS
	ECVS_TOP_DIR=$ECVS_TOP_DIR
	ECVS_SERVER=$ECVS_SERVER
	ECVS_USER=$ECVS_USER
	ECVS_PASS=$ECVS_PASS
	ECVS_MODULE=$ECVS_MODULE
	ECVS_LOCAL=$ECVS_LOCAL
	ECVS_RUNAS=$ECVS_RUNAS
	ECVS_LOCALNAME=$ECVS_LOCALNAME"

	[ -z "$ECVS_MODULE" ] && die "ERROR: CVS module not set, cannot continue."

	local ECVS_LOCALNAME="${ECVS_LOCALNAME}"

	if [ -z "$ECVS_LOCALNAME" ]; then
	    ECVS_LOCALNAME="$ECVS_MODULE"
	fi

	local offline_pkg_var="ECVS_OFFLINE_${PN}"
	if [ "${!offline_pkg_var}" == "1" -o "$ECVS_OFFLINE" == "1" -o "$ECVS_SERVER" == "offline" ]; then
		# We're not required to fetch anything; the module already
		# exists and shouldn't be updated.
	 	if [ -d "${ECVS_TOP_DIR}/${ECVS_LOCALNAME}" ]; then
			debug-print "$FUNCNAME: offline mode"
		else
			debug-print "$FUNCNAME: Offline mode specified but directory ${ECVS_TOP_DIR}/${ECVS_LOCALNAME} not found, exiting with error"
			die "ERROR: Offline mode specified, but directory ${ECVS_TOP_DIR}/${ECVS_LOCALNAME} not found. Aborting."
		fi
	elif [ -n "$ECVS_SERVER" ]; then # ECVS_SERVER!=offline --> real fetching mode
		einfo "Fetching CVS module $ECVS_MODULE into $ECVS_TOP_DIR ..."
		cvs_fetch
	else # ECVS_SERVER not set
		die "ERROR: CVS server not specified, cannot continue."
	fi

	einfo "Copying $ECVS_MODULE from $ECVS_TOP_DIR ..."
	debug-print "Copying module $ECVS_MODULE local_mode=$ECVS_LOCAL from $ECVS_TOP_DIR ..."

	# This is probably redundant, but best to make sure.
	mkdir -p "$WORKDIR/$ECVS_LOCALNAME"

	if [ -n "$ECVS_LOCAL" ]; then
		cp -f "$ECVS_TOP_DIR/$ECVS_LOCALNAME"/* "$WORKDIR/$ECVS_LOCALNAME"
	else
		cp -Rf "$ECVS_TOP_DIR/$ECVS_LOCALNAME" "$WORKDIR/$ECVS_LOCALNAME/.."
	fi

	# If the directory is empty, remove it; empty directories cannot
	# exist in cvs.  This happens when, for example, kde-source
	# requests module/doc/subdir which doesn't exist.  Still create
	# the empty directory in workdir though.
	if [ "`ls -A \"${ECVS_TOP_DIR}/${ECVS_LOCALNAME}\"`" == "CVS" ]; then
		debug-print "$FUNCNAME: removing empty CVS directory $ECVS_LOCALNAME"
		rm -rf "${ECVS_TOP_DIR}/${ECVS_LOCALNAME}"
	fi

	# Implement some of base_src_unpack's functionality; note however
	# that base.eclass may not have been inherited!
	if [ -n "$PATCHES" ]; then
		debug-print "$FUNCNAME: PATCHES=$PATCHES, S=$S, autopatching"
		cd "$S"
		epatch ${PATCHES}
		# Make sure we don't try to apply patches more than once,
		# since cvs_src_unpack is usually called several times from
		# e.g. kde-source_src_unpack
		export PATCHES=""
	fi

	einfo "CVS module ${ECVS_MODULE} is now in ${WORKDIR}"
}

EXPORT_FUNCTIONS src_unpack
